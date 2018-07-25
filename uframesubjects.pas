unit uFrameSubjects;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, ExtCtrls, DbCtrls, StdCtrls,
  Buttons, rxdbgrid, rxlookup, RxDBSpinEdit, rxdbdateedit, RxDBColorBox,
  Dialogs, LCLType, ZDataset, db, clipbrd, graphics, Math, DateUtils,
  Grids, uData, Types, DBGrids, FileUtil, LCLIntf, messages;

type

  { TFrameSubjects }

  TFrameSubjects = class(TFrame)
    BSaveAll: TBitBtn;
    BCancelAll: TBitBtn;
    BOK: TBitBtn;
    BCancel: TBitBtn;
    DBComboMethod: TDBComboBox;
    DBMemo13: TDBMemo;
    DBMemo14: TDBMemo;
    DBMemo6: TDBMemo;
    DBMemo7: TDBMemo;
    DBMemo8: TDBMemo;
    DBMemo9: TDBMemo;
    GridLessons: TRxDBGrid;
    GridMaterials: TRxDBGrid;
    GridSubjects: TRxDBGrid;
    ImageFile: TImageList;
    Label24: TLabel;
    Label26: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    LookupComboModules: TRxDBLookupCombo;
    LookupComboSubjects: TRxDBLookupCombo;
    OpenFile: TOpenDialog;
    PageSubjects: TPageControl;
    PanelMaterials: TPanel;
    PContent: TScrollBox;
    PLessons: TPanel;
    PLookup: TPanel;
    PSubjects: TPanel;
    PModules: TPanel;
    PButtons: TPanel;
    PSubjectsSB: TScrollBox;
    PModulesSB: TScrollBox;
    GridModules: TRxDBGrid;
    RxDBSpinEdit1: TRxDBSpinEdit;
    RxDBSpinEdit2: TRxDBSpinEdit;
    SLessons: TSplitter;
    SSubjects: TSplitter;
    TabPlanning: TTabSheet;
    TabSubjects: TTabSheet;
    UpDownSession: TUpDown;
    ZCoursesactive: TLargeintField;
    ZCoursesbegin: TDateField;
    ZCoursesend: TDateField;
    ZCoursesid: TLargeintField;
    ZCoursesname: TStringField;
    ZCoursesnotes: TMemoField;
    ZCoursesnumber: TLargeintField;
    ZCoursesorder: TLargeintField;
    ZModulesactive: TLargeintField;
    ZModulesduration: TLargeintField;
    ZModulesid: TLargeintField;
    ZModulesname: TStringField;
    ZModulesnotes: TMemoField;
    ZModulesnumber: TLargeintField;
    ZModulessubject: TLargeintField;
    ZStudentsactive: TBooleanField;
    ZStudentsaddress: TMemoField;
    ZStudentsbirth: TDateField;
    ZStudentscourse: TLargeintField;
    ZStudentsemail: TStringField;
    ZStudentsid: TLargeintField;
    ZStudentsname: TStringField;
    ZStudentsnotes: TMemoField;
    ZStudentsnumber: TLargeintField;
    ZStudentsparents: TMemoField;
    ZStudentsphone: TStringField;
    ZStudentspicture: TBlobField;
    ZSubjectsactive: TBooleanField;
    ZSubjectsduration: TLargeintField;
    ZSubjectsid: TLargeintField;
    ZSubjectsname: TStringField;
    ZSubjectsnotes: TMemoField;
    ZSubjectsnumber: TLargeintField;
    ZTeachersactive: TLargeintField;
    ZTeachersaddress: TMemoField;
    ZTeachersemail: TStringField;
    ZTeachersid: TLargeintField;
    ZTeachersname: TStringField;
    ZTeachersnotes: TMemoField;
    ZTeachersnumber: TLargeintField;
    ZTeachersphone: TStringField;
    ZTeacherspicture: TBlobField;
    procedure BCancelAllClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure GridMaterialsCellClick(Column: TColumn);
    procedure GridMaterialsEditButtonClick(Sender: TObject);
    procedure LookupComboSubjectsChange(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BSaveAllClick(Sender: TObject);
    procedure PageSubjectsChange(Sender: TObject);
    procedure PageSubjectsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure PanelEnter(Sender: TObject);
    procedure UpDownSessionClick(Sender: TObject; Button: TUDBtnType);
  private
    OnTable: TZTable;
    MForm: TForm;
    procedure RefreshDBComboMethod;
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure CopyFiles(FileNames: array of String);
    function CreateFileDropSite(const AControl: TControl; const ADropFilesEvent: TDropFilesEvent): TForm;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

procedure TFrameSubjects.RefreshDBComboMethod;
begin
  With Data.ZMethodology do begin
    Refresh;
    First;
    DBComboMethod.Items.Clear;
    While not EOF do begin
      DBComboMethod.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;
end;

function TFrameSubjects.CreateFileDropSite(const AControl: TControl;
  const ADropFilesEvent: TDropFilesEvent): TForm;
begin
  Result := TForm.Create(AControl);
  Result.AllowDropFiles := true;
  Result.BorderStyle := bsNone;
  Result.BoundsRect := AControl.BoundsRect;
  Result.Anchors := AControl.Anchors;
  Result.Align := AControl.Align;
  Result.Parent := AControl.Parent;
  Result.OnDropFiles := ADropFilesEvent;
  AControl.Parent := Result;
  AControl.Align := alClient;
  Result.Visible := true;
end;

procedure TFrameSubjects.FormDropFiles(Sender: TObject; const FileNames: array of String);
begin
  if Sender = MForm then CopyFiles(FileNames);
end;

procedure TFrameSubjects.CopyFiles(FileNames: array of String);
  var destdir, destfilename, FileName: String;
    copy: boolean;
begin
  if length(FileNames) > 0 then begin
    copy := QuestionDlg('Copy or Link','Copy File(s) to Materials Folder?',mtConfirmation,[mrYes,'Yes', mrNo, 'No', 'IsDefault'],'') = mrYes;
    if copy then begin
      Gridmaterials.Cursor := crHourGlass;
      //Main.Cursor := crHourGlass;
      //Self.Cursor := crHourGlass;
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      destdir := ExtractFilePath(ParamStr(0)) + 'materials/' + Data.ZPlanning.FieldByName('id').asString;
      CreateDir(destdir);
    end;
    for FileName in FileNames do begin
      if copy then begin
        destfilename := destdir + '/' + ExtractFileName(FileName);
        if (not fileExists(destfilename))
        or (QuestionDlg('File Already Exists!','Overwrite ' + ExtractFileName(OpenFile.FileName) + '?',mtConfirmation,[mrYes,'Yes', mrNo, 'No', 'IsDefault'],'') = mrYes) then
          if CopyFile(FileName, destfilename) then begin
            if not (Data.ZPlanningMaterials.State in [dsEdit, dsInsert]) then Data.ZPlanningMaterials.Insert;
            Data.ZPlanningMaterials.FieldByName('type').Value := 0;
            Data.ZPlanningMaterials.FieldByName('link').Value := destfilename;
            Data.ZPlanningMaterials.Post;
          end
          else ShowMessage('Copy Failed: ' + FileName);
      end
      else begin
        if not (Data.ZPlanningMaterials.State in [dsEdit, dsInsert]) then Data.ZPlanningMaterials.Insert;
        Data.ZPlanningMaterials.FieldByName('type').Value := 1;
        Data.ZPlanningMaterials.FieldByName('link').Value := FileName;
        Data.ZPlanningMaterials.Post;
      end;
    end;
    Gridmaterials.Cursor := crDefault;
    //Main.Cursor := crDefault;
    //Self.Cursor := crDefault;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrameSubjects.PageSubjectsChange(Sender: TObject);
begin
  if PageSubjects.ActivePage = TabSubjects then begin
    UpDownSession.Visible := false;
    Data.ZSubjects.Refresh;
    Data.ZModules.Refresh;
    PSubjects.SetFocus;
  end
  else begin
    Data.ZPlanning.Refresh;
    Data.ZPlanningMaterials.Refresh;
    UpDownSession.Visible := true;
    PLessons.SetFocus;
  end;
end;

procedure TFrameSubjects.PageSubjectsChanging(Sender: TObject;//Será necessário? E se for só na destruição do PageSubjects?
  var AllowChange: Boolean);
begin
  if Data.onTransaction then begin
    if Application.MessageBox('Save Changes?', 'Pending Changes', MB_ICONQUESTION + MB_YESNO) = IDYES then Data.ZConnection.Commit
    else Data.ZConnection.Rollback;
  end;
end;

procedure TFrameSubjects.PanelEnter(Sender: TObject);
begin
  if Sender = PSubjects then OnTable := Data.ZSubjects
  else if Sender = PModules then OnTable := Data.ZModules
  else if Sender = PLessons then OnTable := Data.ZPlanning
  else if Sender = PContent then OnTable := Data.ZPlanningMaterials;

end;

procedure TFrameSubjects.UpDownSessionClick(Sender: TObject; Button: TUDBtnType
  );
begin
  try
    Data.TableReorder(Data.ZPlanning);
    With Data.ZPlanning do begin
      if Button = btPrev then begin
        Edit;
        FieldByName('pos').Value := FieldByName('pos').Value - 1;
        Post;
        Prior;
        Edit;
        FieldByName('pos').Value := FieldByName('pos').Value + 1;
        Post;
        Prior;
      end
      else begin
        Edit;
        FieldByName('pos').Value := FieldByName('pos').Value + 1;
        Post;
        Next;
        Edit;
        FieldByName('pos').Value := FieldByName('pos').Value - 1;
        Post;
        Next;
      end;
    end;
  except
    Data.ZPlanning.Cancel;
  end;
end;

procedure TFrameSubjects.BOKClick(Sender: TObject);
  var Table: TZTable;
begin
  Table := nil;
  if Data.ZSubjects.State in [dsEdit, dsInsert] then Table := Data.ZSubjects
  else if Data.ZModules.State in [dsEdit, dsInsert] then Table := Data.ZModules
  else if Data.ZPlanning.State in [dsEdit, dsInsert] then Table := Data.ZPlanning
  else if Data.ZPlanningMaterials.State in [dsEdit, dsInsert] then Table := Data.ZPlanningMaterials;
  if Assigned(Table) then Table.Post
  else OnTable.Append;
end;

procedure TFrameSubjects.BSaveAllClick(Sender: TObject);
begin
  Data.ZConnection.Commit;
  RefreshDBComboMethod;
end;

procedure TFrameSubjects.BCancelClick(Sender: TObject);
  var Table: TZTable;
begin
  Table := nil;
  if Data.ZSubjects.State in [dsEdit, dsInsert] then Table := Data.ZSubjects
  else if Data.ZModules.State in [dsEdit, dsInsert] then Table := Data.ZModules
  else if Data.ZPlanning.State in [dsEdit, dsInsert] then Table := Data.ZPlanning
  else if Data.ZPlanningMaterials.State in [dsEdit, dsInsert] then Table := Data.ZPlanningMaterials;
  if Assigned(Table) then Table.Cancel
  else begin
    if OnTable.RecordCount > 0 then begin
      OnTable.Delete;
      Data.TableReorder(OnTable);
      OnTable.Refresh;
    end;
  end;
end;

procedure TFrameSubjects.GridMaterialsCellClick(Column: TColumn);
begin
  if Column.Index = 0 then OpenURL(Data.ZPlanningMaterials.FieldByName('link').AsString);
end;

procedure TFrameSubjects.GridMaterialsEditButtonClick(Sender: TObject);
begin
  if not(Data.ZPlanningMaterials.State in [dsEdit, dsInsert]) then Data.ZPlanningMaterials.Edit;
  if OpenFile.Execute then CopyFiles([OpenFile.FileName]);
end;

procedure TFrameSubjects.LookupComboSubjectsChange(Sender: TObject);
begin
  LookupComboModules.KeyValue := Data.ZModules.FieldByName('id').AsString;
end;

procedure TFrameSubjects.BCancelAllClick(Sender: TObject);
begin
  Data.ZConnection.Rollback;
  if Data.ZSubjects.Active then Data.ZSubjects.Refresh;
  if Data.ZModules.Active then Data.ZModules.Refresh;
  if Data.ZPlanning.Active then Data.ZPlanning.Refresh;
  if Data.ZPlanningMaterials.Active then Data.ZPlanningMaterials.Refresh;
  if Data.ZMethodology.Active then Data.ZMethodology.Refresh;
end;

constructor TFrameSubjects.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Self.Parent := TWinControl(TheOwner);
  Self.Align := alClient;
  Self.BorderStyle:= bsNone;
  PageSubjects.ActivePage := TabSubjects;
  UpDownSession.Visible := false;
  Data.ZSubjects.Open;
  Data.ZModules.Open;
  Data.ZPlanning.MasterFields := 'id';
  Data.ZPlanning.MasterSource := Data.DModules;
  Data.ZPlanning.Open;
  Data.ZMethodology.Open;
  Data.ZPlanningMaterials.Open;
  RefreshDBComboMethod;
  LookupComboSubjects.KeyValue := Data.ZSubjects.FieldByName('id').AsString;
  LookupComboModules.KeyValue := Data.ZModules.FieldByName('id').AsString;
  OnTable := Data.ZSubjects;
  MForm := CreateFileDropSite(GridMaterials, @FormDropFiles);
  PageSubjectsChange(nil);
end;

destructor TFrameSubjects.Destroy;
begin
  MForm.Free;
  Data.ZPlanningMaterials.Close;
  Data.ZPlanning.Close;
  Data.ZMethodology.Close;
  Data.ZModules.Close;
  Data.ZSubjects.Close;
  OnTable := nil;
  OnTable.Free;
  inherited Destroy;
end;

end.

