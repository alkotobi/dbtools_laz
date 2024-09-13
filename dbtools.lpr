program dbtools;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  unidac10,
  liteprovider10,
  myprovider10,
  unit1,
  umain,
  udtm,
  SysUtils,
  udb_basic,
  udb_tools_design,
  SynCommons,
  ugui,
  udb_types,
  ujson { you can add units after this };

  {$R *.res}

begin

  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  dtm := tdtm.Create(nil);
  if not FileExists(make_db_path('db')) then
  begin
    db_create_from_mndatabase(dtm.connection, db_tools_db_def);
  end
  else
    db_update_from_mndatabse(dtm.connection, db_tools_db_def);
  frm_main_create().Show;
  Application.Run;
end.
