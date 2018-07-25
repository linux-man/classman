program classman;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, datetimectrls, sqlite3laz, runtimetypeinfocontrols, rxnew,
  zcomponent, uMain, uData, uFrameCourses, uFrameSchedule,
  uSchedForm, uPlanForm, uFrameSubjects, uFrameEvaluation;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TData, Data);
  Application.Run;
end.

