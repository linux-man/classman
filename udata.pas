unit uData;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, ZDataset, ZConnection, RxSortZeos, db, Buttons, dialogs, graphics, rxlookup,
  ExtCtrls, DbCtrls, ComCtrls, CheckLst, CSVDocument, VpZeosDs, VpBaseDS;

type

  { TData }

  TData = class(TDataModule)
    DEvents: TDataSource;
    DCourseModules: TDataSource;
    DCourseSubjects: TDataSource;
    DMethodology: TDataSource;
    DPlanningMaterials: TDataSource;
    DSubjects: TDataSource;
    DModules: TDataSource;
    DCourses: TDataSource;
    DStudents: TDataSource;
    DTeachers: TDataSource;
    DPlanning: TDataSource;
    RxSortZeos: TRxSortZeos;
    ZCourseSubjectsname: TStringField;
    ZCourseModulesname: TStringField;
    ZCourseSubjectscode: TStringField;
    ZSchedCourseSubjectsname: TStringField;
    ZSchedCourseSubjectscode: TStringField;
    VpCL: TVpControlLink;
    VpZDS: TVpZeosDatastore;
    ZConnection: TZConnection;
    ZCourseModules: TZTable;
    ZCourseModulespos: TLargeintField;
    ZCourseSubjects: TZTable;
    ZCourseSubjectscolor: TLargeintField;
    ZSchedCourseSubjects: TZTable;
    ZCourseSubjectsactive: TLargeintField;
    ZSchedCourseSubjectsactive: TLargeintField;
    ZSchedCourseSubjectsbegin: TDateField;
    ZSchedCourseSubjectscourse: TLargeintField;
    ZSchedCourseSubjectsduration: TLargeintField;
    ZSchedCourseSubjectsid: TLargeintField;
    ZSchedCourseSubjectsnotes: TMemoField;
    ZCourseSubjectspos: TLargeintField;
    ZSchedCourseSubjectspos: TLargeintField;
    ZSchedCourseSubjectssubject: TLargeintField;
    ZSchedCourseSubjectscolor: TLargeintField;
    ZEvents: TZTable;
    ZUnlinkedModules: TZTable;
    ZCourseModulesactive: TLargeintField;
    ZCourseModulesbegin: TDateField;
    ZCourseModulesduration: TLargeintField;
    ZCourseModulesid: TLargeintField;
    ZCourseModulesmodule: TLargeintField;
    ZCourseModulesnotes: TMemoField;
    ZCourseModulessubject: TLargeintField;
    ZCourseSubjectsbegin: TDateField;
    ZCourseSubjectscourse: TLargeintField;
    ZCourseSubjectsduration: TLargeintField;
    ZCourseSubjectsid: TLargeintField;
    ZCourseSubjectsnotes: TMemoField;
    ZCourseSubjectssubject: TLargeintField;
    ZMethodology: TZQuery;
    ZPlanning: TZTable;
    ZPlanningMaterials: TZTable;
    ZQuery: TZReadOnlyQuery;
    ZSubjects: TZTable;
    ZModules: TZTable;
    ZCourses: TZTable;
    ZStudents: TZTable;
    ZTeachers: TZTable;
    ZHolidays: TZTable;
    procedure ZCourseModulesnameGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure TableAfterEdit(DataSet: TDataSet);
    procedure TableAfterCancel(DataSet: TDataSet);
    procedure TableAfterPostDelete(DataSet: TDataSet);
    procedure VpZDSAfterPostEvents(Sender: TObject);
    procedure ZConnectionCommitRollback(Sender: TObject);
    procedure TableBeforePost(DataSet: TDataSet);
    procedure TableReorder(DataSet: TDataSet);
    procedure TableBeforeInsert(DataSet: TDataSet);
    procedure TableBeforeDelete(DataSet: TDataSet);
    procedure TablePostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure TableAfterInsert(DataSet: TDataSet);
    procedure ZCourseSubModsBeforePost(DataSet: TDataSet);
    procedure ZEventsAfterScroll(DataSet: TDataSet);
    procedure ZSubjectsAfterScroll(DataSet: TDataSet);
  private

  public
    onTransaction: boolean;
  end;

var
  Data: TData;

implementation

{$R *.lfm}

uses uMain;//, uFrameSchedule, uFrameTables, uFramePlanning;

{ TData }

procedure TData.TableAfterEdit(DataSet: TDataSet);
begin
  if Assigned(Main.Frame) then begin
    if Assigned(Main.Frame) then begin
      if Main.Frame.FindComponent('PageSchedule') <> nil then begin
        if Main.Frame.FindComponent('BOK') <> nil then (Main.Frame.FindComponent('BOK') as TBitBtn).Visible := true;
        if Main.Frame.FindComponent('BCancel') <> nil then (Main.Frame.FindComponent('BCancel') as TBitBtn).Visible := true;
      end
      else begin
        if Main.Frame.FindComponent('BOK') <> nil then (Main.Frame.FindComponent('BOK') as TBitBtn).Caption := 'OK';
        if Main.Frame.FindComponent('BCancel') <> nil then (Main.Frame.FindComponent('BCancel') as TBitBtn).Caption := 'Cancel';
      end;
    end;
  end;
end;

procedure TData.ZCourseModulesnameGetText(Sender: TField; var aText: string;
  DisplayText: Boolean); //Names must be forced, otherwise empty fields
var Text: Variant;
begin
  try
    Text := Sender.LookupDataSet.Lookup('id', ZCourseModules.FieldByName('module').AsString, 'name');
    if Text <> null then aText := Text
    else aText := '';
  except
    aText := '';
  end;
end;

procedure TData.TableAfterCancel(DataSet: TDataSet);
begin
  if Assigned(Main.Frame) then begin
    if Main.Frame.FindComponent('PageSchedule') <> nil then begin
      if Main.Frame.FindComponent('BOK') <> nil then (Main.Frame.FindComponent('BOK') as TBitBtn).Visible := false;
      if Main.Frame.FindComponent('BCancel') <> nil then (Main.Frame.FindComponent('BCancel') as TBitBtn).Visible := false;
    end
    else begin
      if Main.Frame.FindComponent('BOK') <> nil then (Main.Frame.FindComponent('BOK') as TBitBtn).Caption := 'Insert';
      if Main.Frame.FindComponent('BCancel') <> nil then (Main.Frame.FindComponent('BCancel') as TBitBtn).Caption := 'Delete';
    end;
  end;
end;

procedure TData.TableAfterPostDelete(DataSet: TDataSet);
  var n: integer;
begin
  TableAfterCancel(DataSet);
  onTransaction := true;
  if Main.Frame.FindComponent('BSaveAll') <> nil then (Main.Frame.FindComponent('BSaveAll') as TBitBtn).Visible := true;
  if Main.Frame.FindComponent('BCancelAll') <> nil then (Main.Frame.FindComponent('BCancelAll') as TBitBtn).Visible := true;
  for n := 0 to Main.ToolBar.ButtonCount -1 do Main.ToolBar.Buttons[n].Enabled:= false;
end;

procedure TData.VpZDSAfterPostEvents(Sender: TObject);
begin
  try //To prevent error when creating Resourses
    TableAfterPostDelete(nil);
  except
    onTransaction := false;
  end;
end;

procedure TData.ZConnectionCommitRollback(Sender: TObject);
  var n: integer;
begin
  onTransaction := false;
  if Assigned(Main.Frame) then begin
    if Main.Frame.FindComponent('BSaveAll') <> nil then (Main.Frame.FindComponent('BSaveAll') as TBitBtn).Visible := false;
    if Main.Frame.FindComponent('BCancelAll') <> nil then (Main.Frame.FindComponent('BCancelAll') as TBitBtn).Visible := false;
    for n := 0 to Main.ToolBar.ButtonCount -1 do Main.ToolBar.Buttons[n].Enabled:= true;
  end;
end;

procedure TData.TableBeforePost(DataSet: TDataSet);
begin
  if DataSet = ZPlanningMaterials then begin
    if FileExists(DataSet.FieldByName('link').AsString) then begin //Planning Materials Icons
      if DataSet.FieldByName('link').AsString.StartsWith(ExtractFilePath(ParamStr(0)) + 'materials') then
        DataSet.FieldByName('type').Value := 0
      else DataSet.FieldByName('type').Value := 1;
    end
    else if (DataSet.FieldByName('link').AsString.StartsWith('http', true)) then DataSet.FieldByName('type').Value := 2
    else DataSet.FieldByName('type').Value := null;
  end;
end;

procedure TData.TableReorder(DataSet: TDataSet); //Reorder Courses, Subjects and Modules
  var n: integer;
    B : TBookmark;
begin
  With DataSet do if (FindField('pos') <> Nil) and (RecordCount > 0) then begin
    B := Bookmark;
    DisableControls;
    n := 1;
    First;
    while not EOF do begin
      Edit;
      FieldByName('pos').Value := n;
      Post;
      n := n + 1;
      Next;
    end;
    EnableControls;
    Bookmark := B;
  end;
end;

procedure TData.TableBeforeInsert(DataSet: TDataSet);
begin
  With DataSet as TZTable do begin
    if MasterSource <> nil then begin //Prevent empty MasterSource
      if MasterSource.DataSet.RecordCount = 0 then begin
        ShowMessage('No Record to Associate!');
        Refresh;
        Abort;
      end;
    end;
  end;
end;

procedure TData.TableBeforeDelete(DataSet: TDataSet); //Prevent deletion of related data
begin                                                 //Missing Students, Teachers
  if (DataSet = ZSubjects) then begin
    if (ZModules.RecordCount > 0) then begin
      ShowMessage('Can''t delete when Modules exist!');
      Abort;
    end;
    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from coursesubjects where subject = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Subjects in use!');
      Abort;
    end;
  end
  else if DataSet = ZModules then begin
    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from coursemodules where module = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Modules in use!');
      Abort;
    end;
  end
  else if DataSet = ZCourseModules then begin
{    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from avaliation where module = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Modules with Avaliations!');
      Abort;
    end;}
  end
  else if DataSet = ZCourseSubjects then begin
    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from coursemodules where subject = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Subjects with Modules!');
      Abort;
    end;
  end
  else if DataSet = ZCourses then begin
    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from coursesubjects where course = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Courses with Subjects!');
      Abort;
    end;
  end
  else if DataSet = ZPlanning then begin
    ZQuery.SQL.Clear;
    ZQuery.SQL.add('Select id from planningmaterials where session = ' + DataSet.FieldByName('id').AsString);
    ZQuery.Open;
    if ZQuery.RecordCount > 0 then begin
      ZQuery.Close;
      ShowMessage('Can''t delete Sessions with Materials!');
      Abort;
    end;
  end;
  ZQuery.Close;
end;

procedure TData.TablePostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  DataAction := daAbort;
end;

procedure TData.TableAfterInsert(DataSet: TDataSet);
begin
  TableAfterEdit(DataSet);
  if DataSet.FindField('pos') <> Nil then
    DataSet.FieldByName('pos').Value := DataSet.RecordCount + 1;

  if (DataSet as TZTable).LinkedFields <> '' then
    DataSet.FieldByName((DataSet as TZTable).LinkedFields).Value := (DataSet as TZTable).MasterSource.DataSet.FieldByName((DataSet as TZTable).MasterFields).Value;

  if (DataSet.FindField('name') <> Nil) and (DataSet.FindField('name').FieldKind = fkLookup) then
    DataSet.FieldByName('name').LookupDataSet.Locate('id', DataSet.FieldByName(DataSet.FieldByName('name').KeyFields).value, []);

  if DataSet = ZSubjects then DataSet.FieldByName('name').Value := 'New Subject'
  else if DataSet = ZModules then DataSet.FieldByName('name').Value := 'New Module'
  else if DataSet = ZStudents then DataSet.FieldByName('name').Value := 'New Student'
  else if DataSet = ZTeachers then DataSet.FieldByName('name').Value := 'New Teacher'
  else if DataSet = ZPlanning then DataSet.FieldByName('title').Value := 'New Session'
  else if DataSet = ZPlanningMaterials then DataSet.FieldByName('title').Value := 'New Material'
  else if DataSet = ZCourses then begin
    DataSet.FieldByName('name').Value := 'New Course';
    DataSet.FieldByName('color').Value := clWhite;
  end
  else if DataSet = ZCourseSubjects then DataSet.FieldByName('color').Value := clWhite;
  //else if DataSet = ZCourseModules then DataSet.FieldByName('subject').Value := ZCourseSubjectss.FieldByName('id').Value;
end;

procedure TData.ZCourseSubModsBeforePost(DataSet: TDataSet);
begin
  if DataSet.State = dsInsert then
  if (DataSet.FindField('name') <> Nil) and (DataSet.FindField('name').FieldKind = fkLookup) then begin
    DataSet.FieldByName('name').LookupDataSet.Locate('id', DataSet.FieldByName(DataSet.FieldByName('name').KeyFields).value, []);
    if DataSet.FieldByName('notes').asString = '' then DataSet.FieldByName('notes').Value := DataSet.FieldByName('name').LookupDataSet.FieldByName('notes').Value;
    if DataSet.FieldByName('duration').Value = null then DataSet.FieldByName('duration').Value := DataSet.FieldByName('name').LookupDataSet.FieldByName('duration').Value;
  end;
end;

procedure TData.ZEventsAfterScroll(DataSet: TDataSet);
var n, m: Integer;
  s: Variant;
  CSVStudents, CSVMisses: TCSVDocument;
  CLBMisses: TCheckListBox;
  Image: TDBImage;
begin
  if Assigned(Main.Frame) then begin
    CSVStudents := TCSVDocument.Create;
    CSVStudents.CSVText := ZEvents.FieldByName('UserField2').AsString;
    CSVMisses := TCSVDocument.Create;
    CSVMisses.CSVText := ZEvents.FieldByName('UserField3').AsString;
    ZStudents.SortedFields := 'number';
    //ZStudents.Filtered := false;
    ZStudents.Open; //Data.ZStudents closes on Cancel Add Event(???)
    CLBMisses := (Main.Frame.FindComponent('CLBMisses') as TCheckListBox);
    Image := (Main.Frame.FindComponent('DBImageStudents') as TDBImage);
    Image.Visible := false;
    CLBMisses.Items.Clear;
    for n := 1 to CSVStudents.RowCount - 1 do begin
      if StrToBool(CSVStudents.Cells[1, n]) then begin //Fill CheckListBox
        try
          s := Data.ZStudents.Lookup('id', CSVStudents.Cells[0, n], 'name');
          if s <> null then begin
            CLBMisses.Items.Add(s);
            for m := 0 to CSVMisses.RowCount - 1 do //Fill Misses
            if CSVMisses.Cells[0, m] = CSVStudents.Cells[0, n] then CLBMisses.Checked[CLBMisses.Items.Count - 1] := true;
          end;
        finally
        end;
      end
      else //Remove Misses of Unselected Students
      for m := 0 to CSVMisses.RowCount - 1 do
      if CSVMisses.Cells[0, m] = CSVStudents.Cells[0, n] then begin
        CSVMisses.RemoveRow(m);
        Break;
      end;
    end;
    //Image.Visible := true;
    if CLBMisses.Items.Count > 0 then begin
      //ZStudents.EnableControls;
      Image.Visible := true;
      CLBMisses.Selected[0] := true;
    end;
    //else Image.Visible := false;
    //ZStudents.Filtered := true;
    CSVStudents.Free;
    CSVMisses.Free;
  end;
end;

procedure TData.ZSubjectsAfterScroll(DataSet: TDataSet); //Update Planning Combos
begin
  if Assigned(Main.Frame) then begin
    if Main.Frame.FindComponent('LookupComboModules') <> nil then
    if (ZSubjects.State <> dsInsert) and (ZModules.State <> dsInsert) then begin
      (Main.Frame.FindComponent('LookupComboSubjects') as TRxDBLookupCombo).KeyValue := ZSubjects.FieldByName('id').Value;
      (Main.Frame.FindComponent('LookupComboModules') as TRxDBLookupCombo).KeyValue := ZModules.FieldByName('id').Value;
    end;
  end;
end;

end.

