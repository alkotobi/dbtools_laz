unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, Uni,
  SQLiteUniProvider, MySQLUniProvider;

type

  { TForm1 }

  TForm1 = class(TForm)
    MySQLUniProvider1: TMySQLUniProvider;
    SQLiteUniProvider1: TSQLiteUniProvider;
    UniConnection1: TUniConnection;
    UniTable1: TUniTable;
    UniTable1default_value: TStringField;
    UniTable1description: TMemoField;
    UniTable1display_label: TStringField;
    UniTable1display_width: TLongintField;
    UniTable1field_length: TLongintField;
    UniTable1field_name: TStringField;
    UniTable1field_type: TStringField;
    UniTable1id: TLongintField;
    UniTable1id_table: TLongintField;
    UniTable1is_calculated: TBooleanField;
    UniTable1is_indexed: TBooleanField;
    UniTable1is_not_null: TBooleanField;
    UniTable1is_read_only: TBooleanField;
    UniTable1is_required: TBooleanField;
    UniTable1is_unique: TBooleanField;
    UniTable1is_visible: TBooleanField;
    UniTable2: TUniTable;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

