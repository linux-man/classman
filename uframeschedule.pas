unit uFrameSchedule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, LCLIntf, LCLType, Forms, Controls,
  ComCtrls, ExtCtrls, Buttons, dialogs, db, StdCtrls, Menus, ZDataset, uData,
  VpDayView, VpMisc, VpZeosDs, VpData, VpBaseDS, uSchedForm, uPlanForm, rxspin,
  CSVDocument, rxlookup, rxdbgrid, Graphics, Spin, DbCtrls, CheckLst, Types, DBGrids,
  JvYearGrid, DateUtils, Math;

type

  { TFrameSchedule }

  TFrameSchedule = class(TFrame)
    BCancel: TBitBtn;
    BCancelAll: TBitBtn;
    BOK: TBitBtn;
    BSaveAll: TBitBtn;
    Add: TMenuItem;
    CLBMisses: TCheckListBox;
    DBComboMethod: TDBEdit;
    DBComboMethod1: TDBEdit;
    DBImageStudents: TDBImage;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    Edit: TMenuItem;
    Del: TMenuItem;
    DelAll: TMenuItem;
    GridLessons: TRxDBGrid;
    GridMaterials: TRxDBGrid;
    ImageFile: TImageList;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    LabelCourse: TLabel;
    LabelSubject: TLabel;
    LabelCalendar: TLabel;
    LabelCalendar5: TLabel;
    LabelCalendar6: TLabel;
    LabelCalendar7: TLabel;
    LabelCalendar8: TLabel;
    LabelCalendar9: TLabel;
    LabelDays: TLabel;
    LookupComboCourses: TRxDBLookupCombo;
    LookupComboModule: TRxDBLookupCombo;
    LookupComboSession: TRxDBLookupCombo;
    LookupComboSubjects: TRxDBLookupCombo;
    MSeparator: TMenuItem;
    EditPlanner: TMenuItem;
    NotesMemo: TDBMemo;
    PageLesson: TPageControl;
    PageSchedule: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PButtons: TPanel;
    PopupVpSchedule: TPopupMenu;
    RadioGroupCalendar: TRadioGroup;
    RoomEdit: TDBEdit;
    SpinDays: TSpinEdit;
    Splitter1: TSplitter;
    TabLessons: TTabSheet;
    TabPlanner: TTabSheet;
    TabSchedule: TTabSheet;
    TabLesson: TTabSheet;
    TabPlan: TTabSheet;
    TabCalendar: TTabSheet;
    UpDownCalendar: TUpDown;
    VpPlanner: TVpDayView;
    VpSched: TVpDayView;
    procedure AddClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure CLBMissesItemClick(Sender: TObject; Index: integer);
    procedure CLBMissesSelectionChange(Sender: TObject; User: boolean);
    procedure DelAllClick(Sender: TObject);
    procedure EditPlannerClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure BCancelAllClick(Sender: TObject);
    procedure BSaveAllClick(Sender: TObject);
    procedure GridLessonsDblClick(Sender: TObject);
    procedure GridLessonsGetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure GridMaterialsCellClick(Column: TColumn);
    procedure LookupComboCoursesChange(Sender: TObject);
    procedure LookupComboSessionChange(Sender: TObject);
    procedure LookupComboSubjectsChange(Sender: TObject);
    procedure PageScheduleChange(Sender: TObject);
    procedure PageScheduleChanging(Sender: TObject; var AllowChange: Boolean);
    procedure PageScheduleMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PopupVpSchedulePopup(Sender: TObject);
    procedure SpinDaysChange(Sender: TObject);
    procedure TabCalendarResize(Sender: TObject);
    procedure UpDownCalendarClick(Sender: TObject; Button: TUDBtnType);
    procedure VpPlannerHoliday(Sender: TObject; ADate: TDateTime;
      var AHolidayName: String);
    procedure VpSchedBeforeDrawEvent(Sender: TObject; Event: TVpEvent;
      AActive: Boolean; ACanvas: TCanvas; AGutterRect, AEventRect,
      AIconRect: TRect);
    procedure VpSchedOwnerEditEvent(Sender: TObject; Event: TVpEvent; IsNewEvent: Boolean;
      AResource: TVpResource; var AllowIt: Boolean);
    procedure YearGridYearChanged(Sender: TObject; AYear: Integer);
    procedure YearGridDblClick(Sender: TObject);
    procedure YearGridSelectDate(Sender: TObject; ADate: TDate; InfoText: string; InfoColor: TColor);
  private
    YearGrid1, YearGrid2: TJvYearGrid;
    OnTable: TZTable;
    PlannerDate: TDate;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

uses uMain;

procedure TFrameSchedule.BSaveAllClick(Sender: TObject);
begin
  Data.ZConnection.Commit;
end;

procedure TFrameSchedule.GridLessonsDblClick(Sender: TObject);
begin
  PlannerDate := Trunc(Data.ZEvents.FieldByName('StartTime').Value);
  //Data.VpZDS.Date := VpPlanner.Date;
end;

procedure TFrameSchedule.GridLessonsGetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  try
    if {(Field.FieldName = 'UserField5') and} (Data.ZCourseSubjects.FieldByName('duration').AsInteger > 0) then
    if (Data.ZEvents.FieldByName('UserField9').AsString <> '') and (Data.ZEvents.FieldByName('UserField9').AsFloat > Data.ZCourseSubjects.FieldByName('duration').AsInteger)
    then Background := clYellow;
  finally
  end;
end;

procedure TFrameSchedule.GridMaterialsCellClick(Column: TColumn);
begin
  if Column.Index = 0 then OpenURL(Data.ZPlanningMaterials.FieldByName('link').AsString);
end;

procedure TFrameSchedule.LookupComboCoursesChange(Sender: TObject);
begin
  LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
  //LookupComboSubjects.Enabled := LookupComboSubjects.Value <> '';
end;

procedure TFrameSchedule.LookupComboSessionChange(Sender: TObject);
begin
  TabPlan.TabVisible := LookupComboSession.Text <> '';
  //LookupComboSession.KeyValue := Data.ZPlanning.FieldByName('id').AsString;
  //LookupComboSession.Enabled := LookupComboSession.Value <> '';
end;

procedure TFrameSchedule.LookupComboSubjectsChange(Sender: TObject);
var n: Integer;
  Duration, ModDuration: Real;
  Group: String;
  Groups: TStringList;
begin
  if PageSchedule.ActivePage <> TabLessons then exit;
  Data.ZCourseModules.Locate('id',Data.ZEvents.FieldByName('UserField7').AsString, []);
  LookupComboModule.KeyValue := Data.ZCourseModules.FieldByName('id').asString;
  LookupComboModule.Text := Data.ZCourseModules.FieldByName('name').asString;
  Data.ZPlanning.Locate('id',Data.ZEvents.FieldByName('UserField8').AsString, []);
  LookupComboSession.KeyValue := Data.ZPlanning.FieldByName('id').asString;
  LookupComboSession.Text := Data.ZPlanning.FieldByName('title').asString;
  GridLessons.Enabled := not (Data.ZEvents.RecordCount = 0);
  DBImageStudents.Visible := GridLessons.Enabled;
  PageLesson.Enabled := GridLessons.Enabled;
  Data.ZEvents.DisableControls;
  Data.ZEvents.AfterScroll := nil;
  Groups := TStringList.Create;
  Groups.Sorted := true;
  Groups.Duplicates := dupIgnore;
  Data.ZEvents.First;
  while not Data.ZEvents.EOF do begin
    Groups.Add(Data.ZEvents.FieldByName('UserField4').AsString);
    Data.ZEvents.Next;
  end;
  for Group in Groups do begin
    Data.ZEvents.Filter := 'ResourceID=2 and UserField4=' + QuotedStr(Group);
    Data.ZEvents.First;
    Data.ZCourseModules.First;
    Duration := 0;
    ModDuration := 0;
    n := 1;
    while not Data.ZEvents.EOF do begin
      if Data.ZEvents.FieldByName('UserField5').AsString <> IntToStr(n) then begin
        Data.ZEvents.Edit;
        Data.ZEvents.FieldByName('UserField5').Value := IntToStr(n);
        Data.ZEvents.Post;
      end;
      Duration := Duration + (Data.ZEvents.FieldByName('EndTime').Value - Data.ZEvents.FieldByName('StartTime').Value) * 24;
      ModDuration := ModDuration + (Data.ZEvents.FieldByName('EndTime').Value - Data.ZEvents.FieldByName('StartTime').Value) * 24;
      if Data.ZEvents.FieldByName('UserField9').AsString <> FloatToStr(Duration) then begin
        Data.ZEvents.Edit;
        Data.ZEvents.FieldByName('UserField9').Value := FloatToStr(Duration);
        Data.ZEvents.Post;
      end;
      if (ModDuration >= Data.ZCourseModules.FieldByName('duration').AsFloat) and not Data.ZCourseModules.EOF then begin
        Data.ZCourseModules.Next;
        ModDuration := 0;
      end;
      if (Data.ZEvents.FieldByName('UserField7').AsString = '') and not Data.ZCourseModules.EOF then begin
        Data.ZEvents.Edit;
        Data.ZEvents.FieldByName('UserField7').Value := Data.ZCourseModules.FieldByName('id').AsString;
        Data.ZEvents.Post;
      end;
      n := n + 1;
      Data.ZEvents.Next;
    end;
  end;
  Groups.Free;
  Data.ZEvents.Filter := 'ResourceID=2';
  Data.ZConnection.Commit;
  Data.ZEvents.First;
  Data.ZEvents.AfterScroll := @Data.ZEventsAfterScroll;
  Data.ZEvents.EnableControls;
  Data.ZEventsAfterScroll(nil);
  Data.VpZDS.EventsTable.Refresh;
  Data.VpZDS.RefreshEvents;
end;

procedure TFrameSchedule.PageScheduleChange(Sender: TObject);
begin
  UpDownCalendar.Visible := false;
  LabelCalendar.Visible := false;
  RadioGroupCalendar.Visible := false;
  LabelDays.Visible := false;
  SpinDays.Visible := false;
  BOK.Visible := true;
  BCancel.Visible := true;
  if PageSchedule.ActivePage = TabSchedule then begin
    DelAll.Visible := true;
    MSeparator.Visible := true;
    EditPlanner.Visible := true;
    PlannerDate := VpPlanner.Date;
    Data.VpZDS.ResourceID := 1;
    Data.VpZDS.Date := EncodeDate(2018, 1, 1);
    Data.VpZDS.RefreshEvents;
    VpSched.FixedDate := false;
    VpSched.Date := EncodeDate(2018, 1, 1);
    VpSched.FixedDate := true;
    VpSched.Refresh;
    VpSched.SetFocus;
  end
  else if PageSchedule.ActivePage = TabPlanner then begin
    LabelDays.Visible := true;
    SpinDays.Visible := true;
    DelAll.Visible := false;
    MSeparator.Visible := false;
    EditPlanner.Visible := false;
    //Data.VpZDS.Connected := false;
    Data.VpZDS.ResourceID := 2;
    Data.VpZDS.Date := PlannerDate;
    //Data.VpZDS.Connected := true;
    Data.VpZDS.EventsTable.Refresh;
    Data.VpZDS.RefreshEvents;
    VpPlanner.Date := PlannerDate;
    VpPlanner.Refresh;
  end
  else if PageSchedule.ActivePage = TabLessons then begin
    Data.ZEvents.Open;
    Data.ZEvents.Refresh;
    if VpPlanner.ActiveEvent <> nil then begin
      LookupComboCourses.KeyValue := VpPlanner.ActiveEvent.UserField0;
      LookupComboSubjects.KeyValue := VpPlanner.ActiveEvent.UserField1;
    end
    else begin
      LookupComboCourses.KeyValue := Data.ZCourses.FieldByName('id').AsString;
      LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
    end;
    LookupComboSubjectsChange(nil); //To disable Grid if empty
    if (VpPlanner.ActiveEvent <> nil) then if (VpPlanner.ActiveEvent.UserField5 <> '')
    then Data.ZEvents.Locate('UserField5', VpPlanner.ActiveEvent.UserField5, []);
  end
  else if PageSchedule.ActivePage = TabCalendar then begin
    TabCalendarResize(TabCalendar);
    UpDownCalendar.Visible := true;
    LabelCalendar.Visible := true;
    RadioGroupCalendar.Visible := true;
    BOK.Visible := false;
    BCancel.Visible := false;
  end;
end;

procedure TFrameSchedule.PageScheduleChanging(Sender: TObject;
  var AllowChange: Boolean);
var Index: Integer;
begin
  if Data.onTransaction then begin
    Index := PageSchedule.IndexOfPageAt(TabSchedule.ScreenToControl(Mouse.CursorPos));
    if ((PageSchedule.ActivePageIndex <= 1) and (Index >= 2))
    or (PageSchedule.ActivePageIndex >= 2) then
    if Application.MessageBox('Save Changes?', 'Pending Changes', MB_ICONQUESTION + MB_YESNO) = IDYES then Data.ZConnection.Commit
    else Data.ZConnection.Rollback;
  end;
end;

procedure TFrameSchedule.PageScheduleMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := true;
end;

procedure TFrameSchedule.PopupVpSchedulePopup(Sender: TObject);
begin
  Edit.Visible := ((PageSchedule.ActivePage = TabSchedule) and (VpSched.ActiveEvent <> nil))
  or ((PageSchedule.ActivePage = TabPlanner) and (VpPlanner.ActiveEvent <> nil));
  Del.Visible := Edit.Visible;
end;

procedure TFrameSchedule.SpinDaysChange(Sender: TObject);
begin
  VpPlanner.NumDays := (Sender as TSpinEdit).Value;
end;

procedure TFrameSchedule.TabCalendarResize(Sender: TObject);
var n: integer;
begin
  if assigned(YearGrid1) then begin
    YearGrid1.Height := (Sender as TTabSheet).Height div 2;
    for n := 1 to YearGrid1.RowCount - 1 do YearGrid1.RowHeights[n] := YearGrid1.Height div 13;
    for n := 1 to YearGrid1.ColCount - 1 do YearGrid1.ColWidths[n] := (YearGrid1.Width - YearGrid1.FirstColWidth) div 37;
    YearGrid1.Invalidate;
  end;
  if assigned(YearGrid2) then begin
    YearGrid2.Height := (Sender as TTabSheet).Height div 2;
    for n := 1 to YearGrid2.RowCount - 1 do YearGrid2.RowHeights[n] := YearGrid2.Height div 13;
    for n := 1 to YearGrid2.ColCount - 1 do YearGrid2.ColWidths[n] := (YearGrid2.Width - YearGrid2.FirstColWidth) div 37;
    YearGrid2.Invalidate;
  end;
end;

procedure TFrameSchedule.UpDownCalendarClick(Sender: TObject; Button: TUDBtnType
  );
var n: integer;
begin
  if Button = btNext then n := 1
  else n := -1;
  YearGrid1.Year := YearGrid1.Year + n;
  YearGrid2.Year := YearGrid2.Year + n;
  TabCalendarResize(TabCalendar);
end;

procedure TFrameSchedule.VpPlannerHoliday(Sender: TObject; ADate: TDateTime;
  var AHolidayName: String);
begin
  if Data.ZHolidays.Locate('date', ADate, []) then aHolidayName := 'holiday';
end;

procedure TFrameSchedule.VpSchedBeforeDrawEvent(Sender: TObject;
  Event: TVpEvent; AActive: Boolean; ACanvas: TCanvas; AGutterRect, AEventRect,
  AIconRect: TRect);
var Code, Cl: Variant;
begin
  Data.ZCourses.Filtered := false;
  Data.ZCourseSubjects.Filtered := false;
  Event.Description := '';
  if Event.UserField5 <> '' then Event.Description := Event.UserField5 + ' - ';
  Code := Data.ZCourses.Lookup('id', Event.UserField0, 'code');
  if Code <> null then Event.Description := Event.Description + Code;
  Code := Data.ZSchedCourseSubjects.Lookup('id', Event.UserField1, 'code');
  if Code <> null then Event.Description := Event.Description + ' - ' + Code;
  if trim(Event.UserField4) <> '' then Event.Description := Event.Description + ' - ' + Event.UserField4;
  if trim(Event.Location) <> '' then Event.Description := Event.Description + ' - ' + Event.Location;
  Cl := Data.ZCourses.Lookup('id', Event.UserField0, 'color');
  if Cl = null then Cl := clWhite;
  ACanvas.Brush.Color := Cl;
  ACanvas.Rectangle(AGutterRect);
  Cl := Data.ZSchedCourseSubjects.Lookup('id', Event.UserField1, 'color');
  if Cl = null then Cl := clWhite;
  ACanvas.Brush.Color := Cl;
  ACanvas.Rectangle(AEventRect);
  Data.ZCourses.Filtered := true;
  Data.ZCourseSubjects.Filtered := true;
end;

procedure TFrameSchedule.VpSchedOwnerEditEvent(Sender: TObject;
  Event: TVpEvent;  IsNewEvent: Boolean; AResource: TVpResource; var AllowIt: Boolean);
var EventDlg : TSchedForm;
begin
  EventDlg := TSchedForm.Create(Self);
  if IsNewEvent then Event.EndTime := Event.StartTime + 1 / 24; //Mudar para duração por defeito
  AllowIt := (EventDlg.Execute(Event, AResource.ResourceID) = mrOK) and (Event.UserField0 <> '') and (Event.UserField1 <> ''); //Testar AllowIt
  EventDlg.Free;
end;

procedure TFrameSchedule.BCancelAllClick(Sender: TObject);
begin
  Data.ZConnection.Rollback;
  Data.VpZDS.Connected:=false;
  Data.VpZDS.Connected:=true;
  Data.VpZDS.RefreshEvents;
  Data.ZCourses.Open;
  Data.ZCourseSubjects.Open;
  Data.ZSchedCourseSubjects.Open;
  VpSched.Refresh;
  if Data.ZHolidays.Active then Data.ZHolidays.Refresh;
  YearGridYearChanged(YearGrid1, YearGrid1.Year);
  YearGridYearChanged(YearGrid2, YearGrid2.Year);
end;

procedure TFrameSchedule.AddClick(Sender: TObject);
var StartTime, EndTime: TDateTime;
  Event: TVpEvent;
  DV: TVpDayView;
begin
  if PageSchedule.ActivePage = TabSchedule then DV := VpSched
  else DV := VpPlanner;
  StartTime := DV.Date + DV.ActiveCol + DV.ActiveRow * GranularityMinutes[DV.Granularity] / 1440;
  EndTime := StartTime + 1 / 24; //Mudar para duração por defeito
  Event := Data.VpZDS.Resource.Schedule.AddEvent(Data.VpZDS.GetNextID(Data.VpZDS.EventsTable.Name), StartTime, EndTime);
  DV.ActiveEvent := Event;
  DV.EditSelectedEvent(true);
end;

procedure TFrameSchedule.BCancelClick(Sender: TObject);
begin
  if Data.ZEvents.State in [dsEdit, dsInsert] then Data.ZEvents.Cancel;
end;

procedure TFrameSchedule.BOKClick(Sender: TObject);
begin
  if Data.ZEvents.State in [dsEdit, dsInsert] then Data.ZEvents.Post;
end;

procedure TFrameSchedule.CLBMissesItemClick(Sender: TObject; Index: integer);
var n: Integer;
  CSVStudents, CSVMisses: TCSVDocument;
begin
  CSVStudents := TCSVDocument.Create;
  CSVStudents.CSVText := Data.ZEvents.FieldByName('UserField2').AsString;
  CSVMisses := TCSVDocument.Create;
  //CSVMisses.CSVText := Data.ZEvents.FieldByName('UserField3').AsString;
  //ZStudents.SortedFields := 'number';
  //ZStudents.Open; //Data.ZStudents closes on Cancel Add Event(???)
  for n := 0 to CLBMisses.Items.Count - 1 do
    if CLBMisses.Checked[n] then CSVMisses.AddRow(CSVStudents.Cells[0, n + 1]);
  Data.ZEvents.Edit;
  Data.ZEvents.FieldByName('UserField3').Value := CSVMisses.CSVText;
  //Data.ZEvents.Post;
  CSVStudents.Free;
  CSVMisses.Free;
end;

procedure TFrameSchedule.CLBMissesSelectionChange(Sender: TObject; User: boolean
  );
var n: Integer;
  CSVStudents: TCSVDocument;
begin
  CSVStudents := TCSVDocument.Create;
  CSVStudents.CSVText := Data.ZEvents.FieldByName('UserField2').AsString;
  for n := 0 to CLBMisses.Items.Count - 1 do begin
    if CLBMisses.Selected[n] then Data.ZStudents.Locate('id', CSVStudents.Cells[0, n + 1], []);
  end;
  CSVStudents.Free;
end;

procedure TFrameSchedule.DelAllClick(Sender: TObject);
begin
  if PageSchedule.ActivePage = TabSchedule then begin
    with Data.VpZDS.EventsTable do begin
      First;
      while not EOF do Delete;
    end;
    Data.VpZDS.RefreshEvents;
    VpSched.Refresh;
    Data.VpZDSAfterPostEvents(nil);
  end;
end;

procedure TFrameSchedule.EditPlannerClick(Sender: TObject);
var EventDlg : TPlanForm;
begin
    EventDlg := TPlanForm.Create(Self);
    EventDlg.Execute(VpSched.ActiveEvent);
    EventDlg.Free;
    Data.VpZDS.ResourceID := 1;
    Data.VpZDS.Date := VpSched.Date;
end;

procedure TFrameSchedule.EditClick(Sender: TObject);
begin
  if PageSchedule.ActivePage = TabSchedule then VpSched.EditSelectedEvent
  else VpPlanner.EditSelectedEvent;
end;

procedure TFrameSchedule.DelClick(Sender: TObject);
begin
  if PageSchedule.ActivePage = TabSchedule then VpSched.DeleteActiveEvent(false)
  else VpPlanner.DeleteActiveEvent(false);
end;

procedure TFrameSchedule.YearGridYearChanged(Sender: TObject; AYear: Integer);
begin
  (Sender as TJvYearGrid).ClearBookMarks;
  With Data.ZHolidays do begin
    First;
    While not EOF do begin
      if YearOf(FieldByName('date').Value) = AYear then
        (Sender as TJvYearGrid).SetDayMonthBookmark(DayOf(FieldByName('date').Value), MonthOf(FieldByName('date').Value), true);
      Next;
    end;
  end;
  TabCalendarResize(TabCalendar);
end;

procedure TFrameSchedule.YearGridDblClick(Sender: TObject);
begin
  Abort;
end;

procedure TFrameSchedule.YearGridSelectDate(Sender: TObject; ADate: TDate;
  InfoText: string; InfoColor: TColor);
begin
  if RadioGroupCalendar.ItemIndex = 0 then begin
    (Sender as TJvYearGrid).SetDateBookmark(ADate, true);
    With Data.ZHolidays do
      if not locate('date', ADate, []) then begin
        Insert;
        FieldByName('date').Value := aDate;
        Post;
      end;
  end
  else begin
    (Sender as TJvYearGrid).SetDateBookmark(ADate, false);
    With Data.ZHolidays do
      if locate('date', ADate, []) then begin
        Delete;
        Refresh;
      end;
  end;
 end;

constructor TFrameSchedule.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Self.Parent := TWinControl(TheOwner);
  Self.Align := alClient;
  Self.BorderStyle:= bsNone;
  PageSchedule.ActivePage := TabSchedule;
  Data.VpZDS.Connected := true;
  Data.ZCourses.Filtered := true;
  Data.ZCourseSubjects.Filtered := true;
  //Data.ZCourseModules.Filtered := true;
  Data.ZCourses.Open;
  Data.ZCourseSubjects.Open;
  Data.ZCourseModules.Open;
  Data.ZSchedCourseSubjects.Open;
  //Data.ZStudents.Filtered := true;
  Data.ZStudents.Filtered := false;
  Data.ZStudents.Open;
  Data.ZEvents.Open;
  Data.ZPlanning.MasterFields := 'module';
  Data.ZPlanning.MasterSource := Data.DCourseModules;
  Data.ZPlanning.Open;
  Data.ZPlanningMaterials.Open;
  Data.ZHolidays.Open;
  VpSched.Date := EncodeDate(2018, 1, 1);
  VpSched.FixedDate := true;
  VpPlanner.Date := Date;
  LookupComboCourses.KeyValue := Data.ZCourses.FieldByName('id').AsString;
  LookupComboSubjects.KeyValue := Data.ZCourseSubjects.FieldByName('id').AsString;
  BOK.Visible := false;
  BCancel.Visible := false;

  YearGrid1 := TjvYearGrid.Create(Self);
  YearGrid1.Parent := TabCalendar;
  YearGrid1.Align := alTop;
  YearGrid1.BookMarkColor:= clGray;
  YearGrid1.OnYearChanged := @YearGridYearChanged;
  YearGrid1.OnSelectDate := @YearGridSelectDate;
  YearGrid1.Year := YearOf(Date());
  YearGridYearChanged(YearGrid1, YearOf(Date()));
  //YearGrid1.OnPrepareCanvas := @YearGridPrepareCanvas;
  YearGrid1.OnDblClick := @YearGridDblClick;
  YearGrid2 := TjvYearGrid.Create(Self);
  YearGrid2.Parent := TabCalendar;
  YearGrid2.Align := alClient;
  YearGrid2.BookMarkColor:= clGray;
  YearGrid2.OnYearChanged := @YearGridYearChanged;
  YearGrid2.OnSelectDate := @YearGridSelectDate;
  YearGrid2.Year := YearOf(Date()) + 1;
  //YearGrid2.OnPrepareCanvas := @YearGridPrepareCanvas;
  YearGrid2.OnDblClick := @YearGridDblClick;
  LabelCalendar.Visible := false;
  RadioGroupCalendar.Visible := false;
  UpDownCalendar.Visible := false;
  LabelCalendar.Left := LabelCalendar.Left - (UpDownCalendar.Left - BOK.Left);
  RadioGroupCalendar.Left := RadioGroupCalendar.Left - (UpDownCalendar.Left - BOK.Left);
  UpDownCalendar.Left := BOK.Left;

  PageScheduleChange(nil);

  OnTable := Data.ZPlanning;
end;

destructor TFrameSchedule.Destroy;
begin
  YearGrid1.Free;
  YearGrid2.Free;
  Data.VpZDS.ResourceID := 1;
  Data.VpZDS.Connected := false;
  Data.ZHolidays.Close;
  Data.ZPlanningMaterials.Close;
  Data.ZPlanning.Close;
  Data.ZEvents.Close;
  Data.ZStudents.Close;
  Data.ZCourseModules.Close;
  Data.ZCourseSubjects.Close;
  Data.ZCourses.Close;
  Data.ZSubjects.Close;
  Data.ZSchedCourseSubjects.Close;
  Data.ZCourses.Filtered := false;
  Data.ZCourseSubjects.Filtered := false;
  OnTable := nil;
  OnTable.Free;
  inherited Destroy;
end;

end.

