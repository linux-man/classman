unit uFrameEvaluation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Buttons,
  ComCtrls, rxlookup, rxdbgrid;

type

  { TFrameEvaluation }

  TFrameEvaluation = class(TFrame)
    BCancel: TBitBtn;
    BCancelAll: TBitBtn;
    BOK: TBitBtn;
    BSaveAll: TBitBtn;
    LabelCalendar7: TLabel;
    LabelCourse: TLabel;
    LabelSubject: TLabel;
    LookupComboCourses: TRxDBLookupCombo;
    LookupComboModules: TRxDBLookupCombo;
    LookupComboSubjects: TRxDBLookupCombo;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelCourses: TPanel;
    GridTests: TRxDBGrid;
    PButtons: TPanel;
    SLessons: TSplitter;
    UpDownSession: TUpDown;
  private

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

constructor TFrameEvaluation.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Self.Parent := TWinControl(TheOwner);
  Self.Align := alClient;
  Self.BorderStyle:= bsNone;
  //PageSubjects.ActivePage := TabSubjects;
  //LookupComboSubjects.KeyValue := Data.ZSubjects.FieldByName('id').AsString;
  //LookupComboModules.KeyValue := Data.ZModules.FieldByName('id').AsString;
  //OnTable := Data.ZSubjects;
end;

destructor TFrameEvaluation.Destroy;
begin
  inherited Destroy;
end;

end.

