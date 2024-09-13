unit umain;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  DBGrids, DBCtrls, ExtCtrls, ActnList, DB, SQLiteUniProvider, Uni,
  udtm, udb_tools_design, ugui, udb_basic, udb_types, ujson;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    act_create_pas: TAction;
    ActionList1: TActionList;
    btn_default_data: TButton;
    btn_dot_pas_path1: TButton;
    btn_save_default_data: TButton;
    btn_load_data: TButton;
    btn_create_dot_pas: TButton;
    Button1: TButton;
    DBGrid3: TDBGrid;
    DBGrid5: TDBGrid;
    DBMemo1: TDBMemo;
    DBNavigator3: TDBNavigator;
    DBNavigator4: TDBNavigator;
    dts_data: TDataSource;
    DBGrid2: TDBGrid;
    DBGrid4: TDBGrid;
    dts_fields: TDataSource;
    btn_dot_pas_path: TButton;
    DBNavigator2: TDBNavigator;
    dts_tables: TDataSource;
    DBNavigator1: TDBNavigator;
    dts_databases: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    dlg_open: TOpenDialog;
    Label1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    dlg_save: TSaveDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    tbl_data: TUniTable;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure btn_default_dataClick(Sender: TObject);
    procedure btn_dot_pas_path1Click(Sender: TObject);
    procedure btn_load_dataClick(Sender: TObject);
    procedure btn_save_default_dataClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBGrid3ColEnter(Sender: TObject);
    procedure DBGrid3SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure btn_dot_pas_pathClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure EditorTextChanged(const aCol: integer; const aRow: integer;
      const aText: string);
    procedure btn_create_dot_pasClick(Sender: TObject);
  private
    function get_data_module: tdtm;
  public
    field_type_editor: mneditor;
    property data_module: tdtm read get_data_module;
  end;

var
  frm_main: Tfrm_main;

function frm_main_create(): tfrm_main;
procedure create_default_data();
procedure save_data_as_json(filed_name: string);
procedure load_default_data();

implementation

{$R *.lfm}

{ Tfrm_main }


function create_insert_sql(table_name: string; fields: mnfields): string;
var
  flds, params: string;
  i: integer;
begin
  Result := '    INSERT INTO "' + table_name + '"(';
  flds := '"' + fields[0].field_name + '"';
  params := ':' + fields[0].field_name;
  for i := 1 to Length(fields) - 1 do
  begin
    if fields[i].is_calculated then
      Continue;
    flds := flds + ',"' + fields[i].field_name + '"';
    params := params + ',:' + fields[i].field_name;
  end;
  Result := Result + flds + ')' + sLineBreak + '    VALUES(' + params + ');';

end;

procedure mndatabase_add_table(var dbs: mndatabase; table: mntable);
begin
  SetLength(dbs.tables, Length(dbs.tables) + 1);
  dbs.tables[Length(dbs.tables) - 1] := table;
end;

procedure mntable_add_field(var table: mntable; fld: mnfield);
begin
  SetLength(table.fields, Length(table.fields) + 1);
  table.fields[Length(table.fields) - 1] := fld;
end;

//function mnfield_from_db(dataset: tdataset): mnfield;
//begin
//  Result.field_name := dataset.FieldByName('field_name').AsString;
//  Result.field_type := dataset.FieldByName('field_type').AsString;
//  Result.field_length := dataset.FieldByName('field_length').AsInteger;
//  Result.is_unique := dataset.FieldByName('is_unique').AsBoolean;
//  Result.is_not_null := dataset.FieldByName('is_not_null').AsBoolean;
//  Result.is_indexed := dataset.FieldByName('is_indexed').AsBoolean;
//  Result.default_value := dataset.FieldByName('default_value').AsString;
//  Result.description := dataset.FieldByName('description').AsString;
//  Result.is_required := dataset.FieldByName('is_required').AsBoolean;
//  Result.is_visible := dataset.FieldByName('is_visible').AsBoolean;
//  Result.is_read_only := dataset.FieldByName('is_read_only').AsBoolean;
//  Result.display_width := dataset.FieldByName('display_width').AsInteger;
//  Result.display_label := dataset.FieldByName('display_label').AsString;
//  Result.is_calculated := dataset.FieldByName('is_calculated').AsBoolean;
//end;

//function mntable_get_from_db(tbl_tables, tbl_fields: tdataset): mntable;
//var fld: mnfield;
//begin
//  SetLength(result.fields,0);
//  if tbl_fields.IsEmpty then
//    raise Exception.Create('empty fields');
//  if tbl_tables.IsEmpty then
//    raise Exception.Create('empty tables');
//  result.table_name := tbl_tables.FieldByName('table_name').AsString;
//  Result.default_data := tbl_tables.FieldByName('default_data').AsString;
//  Result.insert_params_count := Length(Result.fields);
//  Result.description := tbl_tables.FieldByName('description').AsString;
//  tbl_fields.First;
//  while not tbl_fields.Eof do
//  begin
//    fld.init_from_db(tbl_fields);
//    mntable_add_field(result, fld);
//    tbl_fields.Next;
//  end;
//  Result.insert_sql := create_insert_sql(Result.table_name, Result.fields);
//end;

function mndatabase_get_from_db(tbl_databases, tbl_tables, tbl_fields:
  TDataSet): mndatabase;
var
  table: mntable;
begin
  Result.init;
  Result.database_name := tbl_databases.FieldByName('database_name').AsString;
  Result.version := tbl_databases.FieldByName('version').AsFloat;
  Result.description := tbl_databases.FieldByName('description').AsString;
  tbl_tables.First;
  while not tbl_tables.EOF do
  begin
    table.init_from_db(tbl_tables, tbl_fields);
    mndatabase_add_table(Result, table);
    tbl_tables.Next;
  end;
end;

procedure Tfrm_main.btn_create_dot_pasClick(Sender: TObject);
var
  database: mndatabase;
begin

  dtm.qry_tables.First;
  dtm.qry_fields.First;
  if dtm.qry_databases.IsEmpty then
    raise Exception.Create('no db');
  if dtm.qry_databases.FieldByName('dot_pas_file_path').IsNull then
    btn_dot_pas_path.Click;
  if dtm.qry_databases.FieldByName('dot_pas_file_path').IsNull then
    exit;
  database := mndatabase_get_from_db(dtm.qry_databases, dtm.qry_tables, dtm.qry_fields);
  create_db_pas_unit(database, dtm.qry_databases.FieldByName(
    'dot_pas_file_path').AsString);
end;

procedure create_default_data();
var
  table: mntable;
  table_name: string;
begin
  table.init_from_db(dtm.qry_tables, dtm.qry_fields);
  table_name := dtm.qry_databases.FieldByName('database_name').AsString +
    '_' + table.table_name + '_data';
  table.table_name := table_name;
  if table_exisis(table_name, connection) then
    update_table(table_name, table.fields, connection)
  else
    create_table(table, connection);
  frm_main.tbl_data.TableName := table_name;
  frm_main.tbl_data.Open;
end;

procedure save_data_as_json(filed_name: string);
var str:string;
begin
  str:= dataset_save_json_array(frm_main.tbl_data);
  dtm.qry_tables.Edit;
  dtm.qry_tables.FieldByName(filed_name).AsString :=str;
  dtm.qry_tables.Post;
end;

procedure load_default_data();
begin
  if frm_main.tbl_data.TableName = '' then
  begin
    create_default_data();
  end;
  if not frm_main.tbl_data.Active then
    frm_main.tbl_data.Open;
  if dtm.qry_tables.FieldByName('default_data').AsWideString = '' then
    raise Exception.Create('no json data');

  dataset_load_json(frm_main.tbl_data, dtm.qry_tables.FieldByName(
    'default_data').AsString);
end;

function frm_main_create(): tfrm_main;
begin
  if not assigned(frm_main) then
  begin
    Application.CreateForm(Tfrm_main, frm_main);
    //frm_main := tfrm_main.Create(application);
    frm_main.dts_databases.DataSet := dtm.qry_databases;
    frm_main.dts_tables.DataSet := dtm.qry_tables;
    frm_main.dts_fields.DataSet := dtm.qry_fields;
    frm_main.tbl_data.Connection:=TUniConnection(dtm.connection);
  end;
  Result := frm_main;
end;

procedure Tfrm_main.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  application.Terminate;
end;

procedure Tfrm_main.EditorTextChanged(const aCol: integer; const aRow: integer;
  const aText: string);
begin
  if dbgrid3.SelectedColumn.Index = acol then
  begin
    ShowMessage(atext);
  end;
end;

procedure Tfrm_main.DBGrid1ColEnter(Sender: TObject);
begin
  //if DBGrid1.SelectedColumn.FieldName = databases_dot_pas_file_path then
  //  DBGrid1.SelectedField := dtm.qry_databases.FieldByName(databases_database_name);
end;

procedure Tfrm_main.btn_default_dataClick(Sender: TObject);
begin
  create_default_data();
end;

procedure Tfrm_main.btn_dot_pas_path1Click(Sender: TObject);
begin
  if dlg_open.Execute then
  begin
    dtm.connection_set_db_name(dlg_open.FileName);
    //dtm.qry_databases.Open;
    //dtm.qry_tables.Open;
    //dtm.qry_field_types.Open;
    //dtm.qry_fields.Open;
  end;
end;

procedure Tfrm_main.btn_load_dataClick(Sender: TObject);
begin
  load_default_data();
end;

procedure Tfrm_main.btn_save_default_dataClick(Sender: TObject);
begin
  save_data_as_json('default_data');
end;

procedure Tfrm_main.Button1Click(Sender: TObject);
begin
  dtm.qry_fields_reset_ind();
end;

procedure Tfrm_main.DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  //if editor is TStringCellEditor then
  //ShowMessage('bb');
  if Editor is TCustomComboBox then
  begin

    TCustomComboBox(editor).AutoCompleteText := [cbactEnabled];
  end;
  //if column.FieldName = databases_database_name then
  //begin
  //  editor := dbedit1;
  //  editor.BoundsRect:=dbgrid1.SelectedFieldRect;
  //end;
end;

procedure Tfrm_main.DBGrid3ColEnter(Sender: TObject);
begin
  //if DBGrid3.SelectedField.FieldName = fields_field_type then
  //begin
  //DBGrid3.SelectedColumn.PickList.Clear;
  //DBGrid3.SelectedColumn.PickList.AddStrings(dtm.lst_fields_type);
  //TCustomComboBox(DBGrid3.InplaceEditor).AutoCompleteText:=[cbactEnabled];
  //end;
end;

procedure field_type_on_validate(Sender: TObject; dispay_text: string);
begin
  if get_id(field_types_table_name, field_types_field_type + '=:type',
    [dispay_text], dtm.connection) <= 0 then
  begin
    if dlg_confirmed(dispay_text) then
    begin
      dtm.qry_field_types.Append;
      dtm.qry_field_types.FieldByName(field_types_field_type).AsString := dispay_text;
      dtm.qry_field_types.Post;
      dtm.qry_fields.FieldByName(fields_field_type).AsString :=
        dtm.qry_field_types.FieldByName(field_types_field_type).AsString;
    end
    else
    begin
      ShowMessage(field_types_field_type + ' cant be empty');
      abort;
    end;
  end;
end;



procedure Tfrm_main.DBGrid3SelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  if DBGrid3.SelectedField.FieldName = 'type' then
  begin
    TCustomComboBox(editor).AutoCompleteText := [cbactEnabled];
    field_type_editor.init(editor, field_type_on_validate);
  end;
end;

procedure Tfrm_main.btn_dot_pas_pathClick(Sender: TObject);
begin
  if dts_databases.DataSet.IsEmpty then
    exit;
  if dlg_save.Execute then
  begin
    dts_databases.DataSet.Edit;
    dts_databases.DataSet.FieldByName(databases_dot_pas_file_path).AsString :=
      dlg_save.FileName;
    Caption := IntToStr(dts_databases.DataSet.FieldByName(
      databases_dot_pas_file_path).Size);
    dts_databases.DataSet.Post;
  end;
end;

function Tfrm_main.get_data_module: tdtm;
begin
  if not Assigned(dtm) then
    udtm.dtm := tdtm.Create(Application);
  Result := udtm.dtm;
end;

end.
