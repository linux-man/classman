unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, ZConnection,  dialogs,
  Sqlite3DS, FileUtil, vpData, uFrameSubjects, uFrameCourses, uFrameSchedule,
  uFrameEvaluation, uData;

type

  { TMain }

  TMain = class(TForm)
    ImageListToolBar: TImageList;
    ToolBar: TToolBar;
    TBEvaluation: TToolButton;
    TBSubjects: TToolButton;
    TBSchedule: TToolButton;
    TBCourses: TToolButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure TBCoursesClick(Sender: TObject);
    procedure TBEvaluationClick(Sender: TObject);
    procedure TBScheduleClick(Sender: TObject);
    procedure TBSubjectsClick(Sender: TObject);
  private

  public
    Frame: TFrame;
  end;

var
  Main: TMain;

implementation

{$R *.lfm}

{ TMain }

procedure TMain.FormShow(Sender: TObject);
  var dsLite : TSqlite3Dataset;
    Res : TVpResource;
begin
  dsLite := TSqlite3Dataset.Create(nil);
  dsLite.FileName := ExtractFilePath(ParamStr(0)) + 'classman.db';
  dsLite.ExecSQL('VACUUM;');
  dsLite.Free;
  {
  ZConnection.LibraryLocation:= '/usr/lib/x86_64-linux-gnu/libsqlcipher.so.0.8.6';
  //ZConnection.Database:= '/home/joao/encrypted.db';
  ZConnection.Properties.Text := 'encrypted=true';
  ZConnection.Password:= 'nova';
  }
  {Don't work
  ZConnection.LibraryLocation:= '/usr/lib/x86_64-linux-gnu/libwxsqlite3-3.0.so.0.0.0';
  ZConnection.Database:= '/home/joao/classman.db_new';
  ZConnection.Properties.Text := 'encrypted=true';
  ZConnection.Password:= 'nova';
  }
  Data.ZConnection.Database:= ExtractFilePath(ParamStr(0)) + 'classman.db';
  Data.ZConnection.Connect;
  Data.VpZDS.AutoCreate := true;
  Data.VpZDS.AutoConnect := false;
  Data.VpZDS.Connection := Data.ZConnection;
  Data.VpZDS.Connected := true;
  if Data.VpZDS.Resources.Count = 0 then begin
    Res := Data.VpZDS.Resources.AddResource(1);
    Res.Description := 'Schedule';
    Res := Data.VpZDS.Resources.AddResource(2);
    Res.Description := 'Planner';
    Data.VpZDS.PostResources;
    Data.ZConnection.Commit;
  end;
  if Data.VpZDS.Resources.Count > 0 then begin
    Data.VpZDS.ResourceID := 1;
  end;
  Data.VpZDS.Connected := false;
  {
  try
    ZConnection.ExecuteDirect('CREATE TABLE teachers ("nome" VARCHAR(255),"num" INTEGER)');
  except end;
  }
end;

procedure TMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  var Files: TStringList;
    n: integer;
begin
  Data.ZPlanningMaterials.MasterSource := nil;
  Data.ZPlanningMaterials.Open;
  Files := FindAllFiles(ExtractFilePath(ParamStr(0)) + 'materials/', '*.*', true);
  for n := 0 to Files.Count - 1 do begin
    if not Data.ZPlanningMaterials.Locate('link', Files[n], []) then DeleteFile(Files[n]);

  end;
  Files.Free;
  FreeAndNil(Frame);
  Data.ZConnection.Disconnect;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := not Data.onTransaction;
end;

procedure TMain.TBSubjectsClick(Sender: TObject);
begin
  If  not(Frame is TFrameSubjects) then begin
    if Assigned(Frame) then FreeAndNil(Frame);
    Frame := TFrameSubjects.Create(Main);
  end;
end;

procedure TMain.TBCoursesClick(Sender: TObject);
begin
  If  not(Frame is TFrameCourses) then begin
    if Assigned(Frame) then FreeAndNil(Frame);
    Frame := TFrameCourses.Create(Main);
  end;
end;

procedure TMain.TBScheduleClick(Sender: TObject);
begin
  If not(Frame is TFrameSchedule) then begin
    if Assigned(Frame) then FreeAndNil(Frame);
    Frame := TFrameSchedule.Create(Main);
  end;
end;

procedure TMain.TBEvaluationClick(Sender: TObject);
begin
  If not(Frame is TFrameEvaluation) then begin
    if Assigned(Frame) then FreeAndNil(Frame);
    Frame := TFrameEvaluation.Create(Main);
  end;
end;

end.

