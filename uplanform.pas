unit uPlanForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Variants,
  Dialogs, DbCtrls, Math, StdCtrls, Buttons, ExtCtrls, uData, rxlookup,
  RxTimeEdit, rxtooledit, VpData;

type

  { TPlanForm }

  TPlanForm = class(TForm)
    BOK: TBitBtn;
    BCancel: TBitBtn;
    CBAllCourses: TCheckBox;
    CBAllSubjects: TCheckBox;
    CBActiveEvent: TCheckBox;
    LabelCalendar2: TLabel;
    SelectAction: TRadioGroup;
    RxFromDate: TRxDateEdit;
    LabelCalendar: TLabel;
    LabelCalendar1: TLabel;
    LabelCalendar3: TLabel;
    LabelCalendar4: TLabel;
    LookupComboCourses: TRxDBLookupCombo;
    LookupComboSubjects: TRxDBLookupCombo;
    RxToDate: TRxDateEdit;
    procedure BOKClick(Sender: TObject);
    procedure CBActiveEventChange(Sender: TObject);
    procedure CBAllCoursesChange(Sender: TObject);
    procedure CBAllSubjectsChange(Sender: TObject);
    procedure LookupComboCoursesChange(Sender: TObject);
  private
    Event: TVpEvent;
  public
    function Execute(Evt: TVpEvent): Integer;
  end;

var
  PlanForm: TPlanForm;

implementation

{$R *.lfm}

{ TPlanForm }

function TPlanForm.Execute(Evt: TVpEvent): Integer;
begin
  Event := Evt;
  if Event <> nil then begin
    CBActiveEvent.Enabled := true;
    CBActiveEvent.Checked := true;
    CBActiveEvent.Caption := 'Active Lesson' + ' - ' + DefaultFormatSettings.LongDayNames[DayOfWeek(Event.StartTime)] + ' - '
    + FormatDateTime('hh:nn', Event.StartTime);
    //LookupComboCourses.KeyValue := StrToInt(Event.UserField0);
    //LookupComboSubjects.KeyValue := StrToInt(Event.UserField1);
  end
  else begin
    CBActiveEvent.Checked := false;
    CBActiveEvent.Enabled := false;
    LookupComboCourses.KeyValue := Data.ZCourses.FieldByName('id').AsString;
    LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
  end;
  Result := Self.ShowModal;
end;

procedure TPlanForm.LookupComboCoursesChange(Sender: TObject);
begin
    LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
end;

procedure TPlanForm.BOKClick(Sender: TObject);
  var n, Day: Integer;
    DayEvents, FoundEvents: TList;

  function FromDateUpdate(FromDate: TDate; Course: Integer; Subject: Integer): TDate;
  var TempDate: Variant;
  begin
    TempDate := Data.ZCourses.Lookup('id', Course, 'begin');
    if TempDate <> null then FromDate := Max(FromDate, TempDate);
    TempDate := Data.ZCourseSubjects.Lookup('id', Subject, 'begin');
    if TempDate <> null then FromDate := Max(FromDate, TempDate);
    Result := FromDate;
  end;

  function ToDateUpdate(ToDate: TDate; Course: Integer): TDate;
  var TempDate: Variant;
  begin
    if ToDate = 0 then ToDate := 1000000;
    TempDate := Data.ZCourses.Lookup('id', Course,'end');
    if TempDate <> null then ToDate := Min(ToDate, TempDate);
    if ToDate = 1000000 then ToDate := 0;
    Result := ToDate;
  end;

  procedure AddEvent(FromDate: TDate; ToDate: TDate; Evt: TVpEvent);
  var StartTime, EndTime: TTime;
    Weekday: Integer;
    NewEvt: TVpEvent;
  begin
    Data.VpZDS.ResourceID := 2;
    FromDate := FromDateUpdate(FromDate, StrToInt(Evt.UserField0), StrToInt(Evt.UserField1));
    ToDate := ToDateUpdate(ToDate, StrToInt(Evt.UserField0));
    StartTime := Frac(Evt.StartTime);
    EndTime := Frac(Evt.EndTime);
    Weekday := DayOfWeek(Evt.StartTime);
    if not((FromDate = 0) or (ToDate = 0)) then begin
      while DayOfWeek(FromDate) <> Weekday do FromDate := FromDate + 1;
      while (FromDate <= ToDate) do begin
        if not Data.ZHolidays.Locate('date', FromDate, []) then begin
          Data.VpZDS.Date := FromDate;
          NewEvt := Data.VpZDS.Resource.Schedule.AddEvent(Data.VpZDS.GetNextID(Data.VpZDS.EventsTable.Name), FromDate + StartTime, FromDate + EndTime);
          NewEvt.UserField0 := Evt.UserField0;
          NewEvt.UserField1 := Evt.UserField1;
          NewEvt.UserField2 := Evt.UserField2;
          NewEvt.UserField4 := Evt.UserField4;
          NewEvt.Location := Evt.Location;
          NewEvt.Notes := ' '; //Otherwise, no save is done(???)
          NewEvt.Notes := Evt.Notes;
          Data.VpZDS.PostEvents;
        end;
        FromDate := FromDate + 7;
      end;
    end;
  end;

  procedure RemEvent(FromDate: TDate; ToDate: TDate; Evt: TVpEvent);
  var Weekday, n: Integer;
    StartTime, EndTime: TTime;
    RDayEvents: TList;
  begin
    Data.VpZDS.ResourceID := 2;
    RDayEvents := TList.Create;
    FromDate := FromDateUpdate(FromDate, StrToInt(Evt.UserField0), StrToInt(Evt.UserField1));
    ToDate := ToDateUpdate(ToDate, StrToInt(Evt.UserField0));
    StartTime := Frac(Evt.StartTime);
    EndTime := Frac(Evt.EndTime);
    Weekday := DayOfWeek(Evt.StartTime);
    if not((FromDate = 0) or (ToDate = 0)) then begin
      while DayOfWeek(FromDate) <> Weekday do FromDate := FromDate + 1;
      while (FromDate <= ToDate) do begin
        Data.VpZDS.Date := FromDate;
        RDayEvents.Clear;
        Data.VpZDS.Resource.Schedule.EventsByDate(FromDate, RDayEvents);
        for n := 0 to RDayEvents.Count-1 do begin
          if (frac(TVpEvent(RDayEvents[n]).StartTime) = StartTime) and (frac(TVpEvent(RDayEvents[n]).EndTime) = EndTime)
          and (TVpEvent(RDayEvents[n]).UserField0 = Evt.UserField0) and (TVpEvent(RDayEvents[n]).UserField1 = Evt.UserField1) then begin
            Data.VpZDS.Resource.Schedule.DeleteEvent(TVpEvent(RDayEvents[n]));
            Data.VpZDS.PostEvents;
          end;
        end;
        FromDate := FromDate + 7;
      end;
    end;
    RDayEvents.Free;
  end;

  procedure RemEvents(FromDate: TDate; ToDate: TDate; Course: Integer; Subject: Integer);
  var n: Integer;
    RDayEvents: TList;
  begin
    Data.VpZDS.ResourceID := 2;
    RDayEvents := TList.Create;
    FromDate := FromDateUpdate(FromDate, Course, Subject);
    ToDate := ToDateUpdate(ToDate, Course);
    if not((FromDate = 0) or (ToDate = 0)) then
    while FromDate <= ToDate do begin
      RDayEvents.Clear;
      Data.VpZDS.Date := FromDate;
      Data.VpZDS.Resource.Schedule.EventsByDate(FromDate, RDayEvents);
      for n := 0 to RDayEvents.Count-1 do begin
        if ((TVpEvent(RDayEvents[n]).UserField0 = IntToStr(Course)) or (Course = -1))
        and ((TVpEvent(RDayEvents[n]).UserField1 = IntToStr(Subject)) or (Subject = -1)) then begin
          Data.VpZDS.Resource.Schedule.DeleteEvent(TVpEvent(RDayEvents[n]));
          Data.VpZDS.PostEvents;
        end;
      end;
      FromDate := FromDate + 1;
    end;
    RDayEvents.Free;
  end;

  procedure RepEvent(FromDate: TDate; ToDate: TDate; Evt: TVpEvent);
  var Weekday, n: Integer;
    StartTime, EndTime: TTime;
    RDayEvents: TList;
    NewEvt: TVpEvent;
  begin
    Data.VpZDS.ResourceID := 2;
    RDayEvents := TList.Create;
    FromDate := FromDateUpdate(FromDate, StrToInt(Evt.UserField0), StrToInt(Evt.UserField1));
    ToDate := ToDateUpdate(ToDate, StrToInt(Evt.UserField0));
    StartTime := Frac(Evt.StartTime);
    EndTime := Frac(Evt.EndTime);
    Weekday := DayOfWeek(Evt.StartTime);
    if not((FromDate = 0) or (ToDate = 0)) then begin
      while DayOfWeek(FromDate) <> Weekday do FromDate := FromDate + 1;
      while (FromDate <= ToDate) do begin
        Data.VpZDS.Date := FromDate;
        RDayEvents.Clear;
        Data.VpZDS.Resource.Schedule.EventsByDate(FromDate, RDayEvents);
        for n := 0 to RDayEvents.Count-1 do begin
          if (frac(TVpEvent(RDayEvents[n]).StartTime) = StartTime) and (frac(TVpEvent(RDayEvents[n]).EndTime) = EndTime)
          then begin
            Data.VpZDS.Resource.Schedule.DeleteEvent(TVpEvent(RDayEvents[n]));
            NewEvt := Data.VpZDS.Resource.Schedule.AddEvent(Data.VpZDS.GetNextID(Data.VpZDS.EventsTable.Name), TVpEvent(RDayEvents[n]).StartTime, TVpEvent(RDayEvents[n]).EndTime);
            NewEvt.UserField0 := Evt.UserField0;
            NewEvt.UserField1 := Evt.UserField1;
            NewEvt.UserField2 := Evt.UserField2;
            NewEvt.UserField4 := Evt.UserField4;
            NewEvt.Location := Evt.Location;
            NewEvt.Notes := ' '; //Otherwise, no save is done(???)
            NewEvt.Notes := Evt.Notes;
            Data.VpZDS.PostEvents;
          end;
        end;
        FromDate := FromDate + 7;
      end;
    end;
    //Data.VpZDS.RefreshEvents;
    RDayEvents.Free;
  end;

  begin
  DayEvents := TList.Create;
  FoundEvents := TList.Create;
  Data.ZCourses.DisableControls;
  Data.ZCourseSubjects.DisableControls;
  if SelectAction.ItemIndex = 0 then begin
    if CBActiveEvent.Checked then AddEvent(RxFromDate.Date, RxToDate.Date, Event) else begin
      for Day := Trunc(EncodeDate(2018, 1, 1)) to Trunc(EncodeDate(2018, 1, 7)) do begin
        DayEvents.Clear;
        Data.VpZDS.Resource.Schedule.EventsByDate(Day, DayEvents);
        for n := 0 to DayEvents.Count-1 do begin
          if
          ((not CBAllCourses.Checked) and (not CBAllSubjects.Checked)
          and (TVpEvent(DayEvents[n]).UserField0 = Data.ZCourses.FieldByName('id').AsString)
          and (TVpEvent(DayEvents[n]).UserField1 = Data.ZCourseSubjects.FieldByName('id').AsString))
          or
          ((not CBAllCourses.Checked) and (CBAllSubjects.Checked)
          and (TVpEvent(DayEvents[n]).UserField0 = Data.ZCourses.FieldByName('id').AsString))
          or
          CBAllCourses.Checked
          then FoundEvents.Add(DayEvents[n]);
        end;
      end;
      for n := 0 to FoundEvents.Count - 1 do AddEvent(RxFromDate.Date, RxToDate.Date, TVpEvent(FoundEvents[n]));
    end;
  end
  else if SelectAction.ItemIndex = 1 then begin
    if CBActiveEvent.Checked then RemEvent(RxFromDate.Date, RxToDate.Date, Event)
    else if (not CBAllCourses.Checked) and (not CBAllSubjects.Checked) then
      RemEvents(RxFromDate.Date, RxToDate.Date,
      Data.ZCourses.FieldByName('id').AsInteger,
      Data.ZCourseSubjects.FieldByName('id').AsInteger)
    else if (not CBAllCourses.Checked) then
      RemEvents(RxFromDate.Date, RxToDate.Date,
      Data.ZCourses.FieldByName('id').AsInteger, -1)
    else
      RemEvents(RxFromDate.Date, RxToDate.Date, -1, -1);
  end
  else RepEvent(RxFromDate.Date, RxToDate.Date, Event);

  Data.ZCourses.EnableControls;
  Data.ZCourseSubjects.EnableControls;
  DayEvents.Free;
  FoundEvents.Free;
  ModalResult := mrOK;
end;

procedure TPlanForm.CBActiveEventChange(Sender: TObject);
begin

  if CBActiveEvent.Checked then SelectAction.Items.Add('Replace')
  else SelectAction.Items.Delete(2);
  LookupComboCourses.Enabled := not CBActiveEvent.Checked;
  LookupComboSubjects.Enabled := not CBActiveEvent.Checked;
  CBAllCourses.Enabled := not CBActiveEvent.Checked;
  CBAllSubjects.Enabled := not CBActiveEvent.Checked;
  if CBActiveEvent.Checked then begin
    if (Event.UserField0 <> '') and (Event.UserField1 <> '') then begin
      LookupComboCourses.KeyValue := StrToInt(Event.UserField0);
      LookupComboSubjects.KeyValue := StrToInt(Event.UserField1);
    end
  end;
end;

procedure TPlanForm.CBAllCoursesChange(Sender: TObject);
begin
  CBAllSubjects.Checked := CBAllCourses.Checked;
  CBAllSubjects.Enabled := not CBAllCourses.Checked;
  LookupComboCourses.Enabled := not CBAllCourses.Checked;
end;

procedure TPlanForm.CBAllSubjectsChange(Sender: TObject);
begin
  LookupComboSubjects.Enabled := not CBAllSubjects.Checked;
end;

end.

