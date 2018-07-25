unit uSchedForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  Math, StdCtrls, Buttons, ExtCtrls, CheckLst, uData, rxlookup, CSVDocument,
  RxTimeEdit, rxtooledit, VpData;

type

  { TSchedForm }

  TSchedForm = class(TForm)
    BOK: TBitBtn;
    BCancel: TBitBtn;
    CBDone: TCheckBox;
    CLBStudents: TCheckListBox;
    LabelCalendar7: TLabel;
    LabelGroup: TLabel;
    LabelDone: TLabel;
    RoomEdit: TEdit;
    LabelCalendar5: TLabel;
    LabelCalendar6: TLabel;
    NotesMemo: TMemo;
    DatePicker: TRxDateEdit;
    GroupEdit: TEdit;
    WeekDayBox: TComboBox;
    LabelCalendar: TLabel;
    LabelCalendar1: TLabel;
    LabelDate: TLabel;
    LabelCalendar3: TLabel;
    LabelCalendar4: TLabel;
    LookupComboCourses: TRxDBLookupCombo;
    LookupComboSubjects: TRxDBLookupCombo;
    StartTimeEdit: TRxTimeEdit;
    EndTimeEdit: TRxTimeEdit;
    procedure BOKClick(Sender: TObject);
    procedure EndTimeEditChange(Sender: TObject);
    procedure LookupComboCoursesChange(Sender: TObject);
    procedure StartTimeEditChange(Sender: TObject);
  private
    Event: TVpEvent;
    Delta: TTime;
    ResourceID: Integer;
  public
    function Execute(Evt: TVpEvent; Resource: Integer): Integer;
  end;

var
  SchedForm: TSchedForm;

implementation

{$R *.lfm}

{ TSchedForm }

function TSchedForm.Execute(Evt: TVpEvent; Resource: Integer): Integer;
var n: Integer;
begin
  Event := Evt;
  Delta := Event.EndTime - Event.StartTime;
  ResourceID := Resource; //Store to BOKClick
  if (Event.UserField0 <> '') and (Event.UserField1 <> '') then begin //Selected Event
    LookupComboCourses.KeyValue := StrToInt(Event.UserField0);
    LookupComboSubjects.KeyValue := StrToInt(Event.UserField1);
  end
  else begin //New Event
    LookupComboCourses.KeyValue := Data.ZCourses.FieldByName('id').AsString;
    LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
  end;
  if Resource = 1 then begin //Schedule
    WeekDayBox.Items.Clear;
    for n := 2 to High(DefaultFormatSettings.LongDayNames) Do
      WeekDayBox.Items.Add(DefaultFormatSettings.LongDayNames[n]);
    WeekDayBox.Items.Add(DefaultFormatSettings.LongDayNames[1]);
    WeekDayBox.Visible := true;
    DatePicker.Visible := false;
    LabelDate.Caption := 'Weekday';
    LabelDone.Visible := false;
    CBDone.Visible := false;
    CBDone.Checked := false;;
    WeekDayBox.ItemIndex := Trunc(Event.StartTime - EncodeDate(2018, 1, 1)) ;
  end
  else begin //Planner
    WeekDayBox.Visible := false;
    DatePicker.Visible := true;
    LabelDate.Caption := 'Date';
    LabelDone.Visible := true;
    CBDone.Visible := true;
    CBDone.Checked := Event.AlarmSet;
    DatePicker.Date := Trunc(Event.StartTime);
  end;
  StartTimeEdit.Time := Frac(Event.StartTime);
  EndTimeEdit.Time := Frac(Event.EndTime);
  RoomEdit.Text := Event.Location;
  NotesMemo.Text := Event.Notes;
  GroupEdit.Text := Event.UserField4;
  Result := Self.ShowModal;
end;

procedure TSchedForm.LookupComboCoursesChange(Sender: TObject);
var n: Integer;
  s: Variant;
  CSVStudents: TCSVDocument;
begin
  CSVStudents := TCSVDocument.Create;
  LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
  Data.ZStudents.SortedFields := 'number';
  Data.ZStudents.Open; //Data.ZStudents closes on Cancel Add Event(???)
  CSVStudents.CSVText := Event.UserField2;
  if (CSVStudents.RowCount = 0) or
  not(CSVStudents.Cells[0, 0] = Data.ZCourses.FieldByName('id').asString) //If there are no Students or Course changed
  then begin
    CSVStudents.Clear;
    CSVStudents.AddRow(Data.ZCourses.FieldByName('id').AsString); //First Row stores Course ID
    Data.ZStudents.First;
    While not Data.ZStudents.EOF do begin
      if Data.ZStudents.FieldByName('active').AsBoolean then begin //Active Students are stored with True
        CSVStudents.AddRow(Data.ZStudents.FieldByName('id').asString);
        CSVStudents.AddCell(CSVStudents.RowCount - 1, BoolToStr(true));
      end;
      Data.Zstudents.Next;
    end;
    Event.UserField2 := CSVStudents.CSVText;
  end;
  CLBStudents.Items.Clear;
  //Data.ZStudents.Filtered := false;
  for n := 1 to CSVStudents.RowCount - 1 do begin //Fill CheckListBox
    try
      s := Data.ZStudents.Lookup('id', CSVStudents.Cells[0, n], 'name');
      if s <> null then begin
        CLBStudents.Items.Add(s);
        CLBStudents.Checked[CLBStudents.Items.Count - 1] := StrToBool(CSVStudents.Cells[1, n]);
      end;
    finally
    end;
  end;
  //Data.ZStudents.Filtered := true;
  CSVStudents.Free;
end;

procedure TSchedForm.StartTimeEditChange(Sender: TObject);
begin
  EndTimeEdit.Time := StartTimeEdit.Time + Delta; //Delta: EndTime - StartTime
end;

procedure TSchedForm.EndTimeEditChange(Sender: TObject);
begin
  EndTimeEdit.Time := Max(EndTimeEdit.Time, StartTimeEdit.Time + 15/1440); //Limit Events to 15 min minimum
  Delta := EndTimeEdit.Time - StartTimeEdit.Time;
end;

procedure TSchedForm.BOKClick(Sender: TObject);
var n, m: Integer;
  CSVStudents, CSVMisses: TCSVDocument;
begin
  CSVStudents := TCSVDocument.Create;
  CSVMisses := TCSVDocument.Create;
  if ResourceID = 1 then begin //Schedule
    Event.StartTime := EncodeDate(2018, 1, 1) + WeekDayBox.ItemIndex + StartTimeEdit.Time;
    Event.EndTime := EncodeDate(2018, 1, 1) + WeekDayBox.ItemIndex + EndTimeEdit.Time;
  end
  else begin //Planner
    Event.StartTime := DatePicker.Date + StartTimeEdit.Time;
    Event.EndTime := DatePicker.Date + EndTimeEdit.Time;
  end;
  CSVStudents.CSVText := Event.UserField2;
  CSVMisses.CSVText := Event.UserField3;
  for n := 0 to CLBStudents.Items.Count - 1 do begin
    CSVStudents.Cells[1, n + 1] := BoolToStr(CLBStudents.Checked[n]); //Save Selected Students
    if (CSVMisses.RowCount > 0) and not CLBStudents.Checked[n] then //Remove Misses of Unselected Students
    for m := 0 to CSVMisses.RowCount - 1 do
    if CSVMisses.Cells[0, m] = CSVStudents.Cells[0, n + 1] then begin
      CSVMisses.RemoveRow(m);
      Break;
    end;
  end;
  Event.UserField0 := Data.ZCourses.FieldByName('id').asString;
  Event.UserField1 := Data.ZCourseSubjects.FieldByName('id').asString;
  Event.UserField2 := CSVStudents.CSVText;
  Event.UserField3 := CSVMisses.CSVText;
  Event.Location := RoomEdit.Text;
  Event.Notes := NotesMemo.Text;
  Event.UserField4 := GroupEdit.Text;
  Event.AlarmSet := CBDone.Checked;
  CSVMisses.Free;
  CSVStudents.Free;
end;

end.

