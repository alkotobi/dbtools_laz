unit udtm;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DB, upaths, udb_basic,
  udb_tools_design, SQLiteUniProvider, udb_types, ujson, LazFileUtils;

type

  { Tdtm }

  Tdtm = class(TDataModule)
    UniTable1database_name: TStringField;
    UniTable1description: TMemoField;
    UniTable1dot_pas_file_path: TStringField;
    UniTable1id: TLongintField;
    UniTable1version: TFloatField;
    UniTable2default_value: TStringField;
    UniTable2description: TMemoField;
    UniTable2display_label: TStringField;
    UniTable2display_width: TLongintField;
    UniTable2field_length: TLongintField;
    UniTable2field_name: TStringField;
    UniTable2field_type: TStringField;
    UniTable2id: TLongintField;
    UniTable2id_table: TLongintField;
    UniTable2is_calculated: TBooleanField;
    UniTable2is_indexed: TBooleanField;
    UniTable2is_not_null: TBooleanField;
    UniTable2is_read_only: TBooleanField;
    UniTable2is_required: TBooleanField;
    UniTable2is_unique: TBooleanField;
    UniTable2is_visible: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    fqry_databases: tdataset;
    fconnection: TCustomConnection;
    fqry_tables: tdataset;
    fqry_fields: tdataset;
    flst_fields_type: TStringList;
    fqry_field_types: tdataset;
    do_fields_after_post: boolean;
    field_index: integer;
    function get_connection: TCustomConnection;
    function get_lst_fields_type: TStringList;
    function get_qry_databases: tdataset;
    function get_qry_fields: tdataset;
    function get_qry_field_types: tdataset;
    function get_qry_tables: tdataset;
  public
    property connection: TCustomConnection read get_connection;
    property qry_databases: tdataset read get_qry_databases;
    property qry_tables: tdataset read get_qry_tables;
    property qry_fields: tdataset read get_qry_fields;
    property qry_field_types: tdataset read get_qry_field_types;
    property lst_fields_type: TStringList read get_lst_fields_type;
    procedure create_db();
    procedure lst_fields_type_refresh();
    destructor Destroy; override;
    procedure connection_set_db_name(db_name: string);
    procedure qry_fields_after_post(dataset: tdataset);
    procedure qry_fields_after_scroll(dataset: tdataset);
    procedure qry_fields_reset_ind();
    procedure qry_fields_before_insert(sender:tdataset);
  end;

function get_db_path(): string;
function make_db_path(db_name_without_ext: string): string;
function create_db_pas_unit(db_def: mndatabase; path: string): string;




var
  dtm: Tdtm;

implementation

{$R *.lfm}

{ Tdtm }

function get_type_from_db(data_type: TFieldType): string;
begin
  case data_type of
    TFieldType.ftBlob, TFieldType.ftMemo, TFieldType.ftString,
    TFieldType.ftWideString: Result := 'string';
    TFieldType.ftBoolean: Result := 'boolean';
    TFieldType.ftDate, TFieldType.ftDateTime: Result := 'double';
    TFieldType.ftCurrency: Result := 'currency';
    TFieldType.ftFloat: Result := 'double';
    TFieldType.ftInteger, TFieldType.ftLargeint, TFieldType.ftSmallint: Result :=
        'integer';
    else
      raise Exception.Create('data type not handeled:' + IntToStr(Ord(data_type)));
  end;

end;

function create_const_flds_from_db(qry: tdataset): string;
var
  i: integer;
  str: string;
begin
  i := 0;
  while qry.Fields[i].Visible = False do
  begin
    i := i + 1;
  end;
  str := '''' + qry.Fields[i].FieldName + ':' + get_type_from_db(
    qry.Fields[i].DataType) + ';''+' + sLineBreak;
  i := i + 1;
  while i < qry.FieldCount do
  begin
    if not qry.Fields[i].Visible then
    begin
      i := i + 1;
      Continue;
    end;
    str := str + sLineBreak + '''' + qry.Fields[i].FieldName + ':' +
      get_type_from_db(qry.Fields[i].DataType) + ';''+' + sLineBreak;
    i := i + 1;
  end;
  Result := str;
end;


function create_db_pas_unit(db_def: mndatabase; path: string): string;
var
  i, j: integer;
  table_name, field_name, str: string;
  strs: TStringList;

  function multi_line_str(lst: TStringList): string;
  var
    k: integer;
  begin
    Result := '';
    for k := 0 to lst.Count - 2 do
    begin
      Result := Result + '''' + lst.Strings[k] + '''' + '+' + sLineBreak;
    end;
    //showmessage(inttostr(k)+' count:'+inttostr(lst.Count));
    Result := Result + '''' + lst.Strings[k + 1] + '''';
    //lst.Delimiter:=',';
    //result := lst.DelimitedText;
    //arr:= lst.ToStringArray;
    //for k:=0 to length(arr)-1 do
    //begin
    //  arr[k]:=''''+arr[k]+''''+sLineBreak;
    //end;
    //result := string.Join('+',arr);
  end;

begin
  if path = '' then
    exit;
  strs := TStringList.Create;
  strs.Text := serialize<mndatabase>(db_def);
  str := multi_line_str(strs);
  strs.Clear;
  Result := 'unit ' + ExtractFileNameOnly(path) + ';' + sLineBreak + sLineBreak;
  Result := Result + '{$mode delphi}{$H+}' + sLineBreak;
  Result := Result + '     interface' + sLineBreak + '     uses' +
    sLineBreak + '        classes,' + sLineBreak + '        ujson,' +
    sLineBreak + '        SysUtils,' + sLineBreak + '        udb_types,' +
    sLineBreak + '        SynCommons;' + sLineBreak + sLineBreak +
    '     const' + sLineBreak + '      db_version =' + FloatToStr(db_def.version) + ';';
  Result := Result + sLineBreak + '   ' + db_def.database_name +
    '_json=' + str + ';' + sLineBreak;
  for i := 0 to Length(db_def.tables) - 1 do
  begin
    table_name := db_def.tables[i].table_name;
    Result := Result + sLineBreak + Format(sLineBreak +
      '    //----------------------------%s---------------------------------' +
      sLineBreak, [table_name]);
    strs.Text := get_sql_create_table(table_name, db_def.tables[i].fields);
    str := multi_line_str(strs);
    strs.Clear;
    Result := Result + sLineBreak + '   ' + table_name + '_table_name=''' +
      table_name + '''' + ';';
    Result := Result + sLineBreak + Format('   sql_%s_tbl_create= %s ;' +
      sLineBreak, [table_name, str]);
    for j := 0 to Length(db_def.tables[i].fields) - 1 do
    begin
      field_name := db_def.tables[i].fields[j].field_name;
      Result := Result + sLineBreak + '     ' + table_name + '_' +
        field_name + '=' + '''' + field_name + '''' + ';';
    end;
    strs.Text := db_def.tables[i].insert_sql;
    str := multi_line_str(strs);
    strs.Clear;
    Result := Result + sLineBreak + format('sql_%s_insert=%s;' +
      sLineBreak, [table_name, str]);
  end;
  str := db_def.database_name + '_def';
  Result := Result + sLineBreak + ' var ' + sLineBreak + '   ' +
    str + ':mndatabase;' + sLineBreak + 'implementation' + sLineBreak +
    'initialization' + sLineBreak +
    '    TTextWriter.RegisterCustomJSONSerializerFromText(' +
    ' TypeInfo(' + str +
    '),__mndatabase_entry_value).Options := [soReadIgnoreUnknownFields,soWriteHumanReadable];'
    + sLineBreak + ' ' + str + ' := deserializer<mndatabase>(' +
    db_def.database_name + '_json);' + sLineBreak + 'END.';

  try
    strs.Text := Result;
    strs.SaveToFile(path);
  finally
    strs.Free;
  end;
end;

procedure Tdtm.DataModuleCreate(Sender: TObject);
begin
  do_fields_after_post := True;
end;

function Tdtm.get_connection: TCustomConnection;
var
  db_name: string;
begin
  if not Assigned(fconnection) then
  begin
    db_name := make_db_path('db');
    fconnection := connection_create(provider_name_sqlite, db_name, self);
    connection_add(fconnection);
    fconnection.Open;
  end;
  Result := fconnection;
end;

function Tdtm.get_lst_fields_type: TStringList;
begin
  if not assigned(flst_fields_type) then
  begin
    flst_fields_type := TStringList.Create;
    qry_field_types.First;
    while not qry_field_types.EOF do
    begin
      flst_fields_type.Add(qry_field_types.FieldByName(
        field_types_field_type).AsString);
      qry_field_types.Next;
    end;
    qry_field_types.First;
  end;
  Result := flst_fields_type;
end;

function Tdtm.get_qry_databases: tdataset;
begin
  if not Assigned(fqry_databases) then
  begin
    fqry_databases := qry_create_with_table_name(
      self.connection, databases_table_name, self);
    dataset_add_fields(fqry_databases, table_get_by_name(
      db_tools_db_def.tables, databases_table_name));
    fqry_databases.Open;
  end;
  Result := fqry_databases;
end;

function Tdtm.get_qry_fields: tdataset;
begin
  if not assigned(fqry_fields) then
  begin
    fqry_fields := qry_create_with_sql(self.connection, 'SELECT * FROM ' +
      fields_table_name + ' ORDER BY "ind"', [], self);
    dataset_add_fields(fqry_fields, table_get_by_name(db_tools_db_def.tables,
      fields_table_name));
    dataset_connect_to_master(qry_fields, qry_tables, 'id', fields_id_table);
    dataset_add_string_field(fqry_fields, 'type', 'TYPE', 15, 20, True).set_lookup(
      fqry_fields.FieldByName(fields_field_type), qry_field_types, fields_field_type,
      field_types_field_type, field_types_field_type).set_index(3);
    fqry_fields.FieldByName(fields_field_type).set_visible(False);
    fqry_fields.AfterPost := self.qry_fields_after_post;
    fqry_fields.AfterScroll := self.qry_fields_after_scroll;
    qry_fields.BeforeInsert:=qry_fields_before_insert;
    fqry_fields.Open;
  end;
  Result := fqry_fields;
end;

function Tdtm.get_qry_field_types: tdataset;
begin
  if not assigned(fqry_field_types) then
  begin
    fqry_field_types := qry_create_with_table_name(
      connection, field_types_table_name, self);
    dataset_add_fields(fqry_field_types, db_tools_db_def, field_types_table_name);
    fqry_field_types.Open;
    //fqry_field_types.First;
    //fqry_fields.FieldByName(fields_field_type).LookupCache:=true;
    //while not fqry_field_types.EOF do
    //begin
    //  qry_fields.FieldByName(fields_field_type).LookupList.Add(fqry_field_types.FieldByName(field_types_field_type).AsString,
    //    fqry_field_types.FieldByName(field_types_field_type).AsString);
    //  fqry_field_types.Next;
    //end;
  end;
  Result := fqry_field_types;
end;

function Tdtm.get_qry_tables: tdataset;
begin
  if not assigned(fqry_tables) then
  begin
    fqry_tables := qry_create_with_table_name(self.connection, tables_table_name, self);
    dataset_add_fields(fqry_tables, table_get_by_name(db_tools_db_def.tables,
      tables_table_name));
    dataset_connect_to_master(qry_tables, qry_databases, 'id', tables_id_databse);

    fqry_tables.Open;
  end;
  Result := fqry_tables;
end;

procedure Tdtm.create_db();
begin
  db_create_from_json(self.connection, db_tools_db_json);
end;

procedure Tdtm.lst_fields_type_refresh();
begin
  flst_fields_type.Clear;
  qry_field_types.First;
  while not qry_field_types.EOF do
  begin
    flst_fields_type.Add(qry_field_types.FieldByName(
      field_types_field_type).AsString);
    qry_field_types.Next;
  end;
  qry_field_types.FieldByName(
    field_types_field_type).LookupList;
  qry_field_types.First;
end;

destructor Tdtm.Destroy;
begin
  inherited Destroy;
  flst_fields_type.Free;
end;

procedure Tdtm.connection_set_db_name(db_name: string);
var
  i: integer;
  str:string;
begin
  connection.Close();
  udb_basic.connection_set_db_name(connection, db_name);
  connection.Open;
  db_update_from_mndatabse(connection, db_tools_db_def);

  for i := 0 to (connection).DataSetCount - 1 do
  begin
    str:=qry_get_sql(connection.datasets[i]);
    connection.datasets[i].Open;
  end;
end;

procedure Tdtm.qry_fields_after_post(dataset: tdataset);
var
  id: integer;
  qry: tdataset;
begin
  if not do_fields_after_post then exit;
  do_fields_after_post := False;
  id := dataset.FieldByName('id').AsInteger;
  if dataset.FieldByName('ind').IsNull then
  begin
    dataset.Edit;
    dataset.FieldByName('ind').AsInteger := id;
    dataset.Post;
  end
  else
  begin
    try
      qry := qry_create_with_sql(connection,
        'UPDATE fields set ind=:ind1 WHERE id !=:id and ind=:ind2', [field_index, id,
        dataset.FieldByName('ind').Value]);
      qry_exec(qry);
    finally
      qry.Free;
    end;
    dataset.Refresh;
    dataset.Filter:='id='+inttostr(id);
    dataset.FindFirst;
  end;
  do_fields_after_post := True;
end;

procedure Tdtm.qry_fields_after_scroll(dataset: tdataset);
begin
  if not do_fields_after_post then exit;
  if not qry_fields.FieldByName('ind').IsNull then
  begin
    field_index := qry_fields.FieldByName('ind').AsInteger;
  end
  else
    field_index:=0;
end;

procedure Tdtm.qry_fields_reset_ind();
var
  bk: TBookMark;
begin
  bk := qry_fields.GetBookmark;
  qry_fields.First;
  do_fields_after_post := False;
  while not qry_fields.EOF do
  begin
    qry_fields.Edit;
    qry_fields.FieldByName('ind').AsInteger := qry_fields.RecNo;
    qry_fields.Post;
    qry_fields.Next;
  end;
  qry_fields.GotoBookmark(bk);
  qry_fields.Refresh;
  do_fields_after_post := True;
end;

procedure Tdtm.qry_fields_before_insert(sender: tdataset);
begin
  if qry_tables.State in [dsEdit,dsInsert] then
  begin
    qry_tables.Post;
  end;
end;


function get_db_path(): string;
begin
  Result := get_documents_dir() + DirectorySeparator + 'dbtools';
  if not DirectoryExists(Result) then
    MkDir(Result);
end;

function make_db_path(db_name_without_ext: string): string;
begin
  Result := get_db_path() + DirectorySeparator + db_name_without_ext + '.db';
end;

finalization

end.
