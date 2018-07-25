unit uFrameCourses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, ExtCtrls, DbCtrls, StdCtrls,
  Buttons, rxdbgrid, rxlookup, RxDBSpinEdit, rxdbdateedit, RxDBColorBox,
  Dialogs, LCLType, ZDataset, db, clipbrd, graphics, Math, DateUtils,
  Grids, uData, Types, DBGrids, FileUtil, LCLIntf, messages;

type

  { TFrameCourses }

  TFrameCourses = class(TFrame)
    BClearImageS: TBitBtn;
    BPasteImageT: TBitBtn;
    BClearImageT: TBitBtn;
    BPasteImageS: TBitBtn;
    BSaveAll: TBitBtn;
    BCancelAll: TBitBtn;
    BOK: TBitBtn;
    BCancel: TBitBtn;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBImageT: TDBImage;
    DBImageS: TDBImage;
    DBLookupComboBox3: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo10: TDBMemo;
    DBMemo11: TDBMemo;
    DBMemo12: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    DBMemo5: TDBMemo;
    GridCourses: TRxDBGrid;
    GridCourseSubjects: TRxDBGrid;
    ImageFile: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenFile: TOpenDialog;
    PageCourses: TPageControl;
    GridTeachers: TRxDBGrid;
    PCourses: TPanel;
    PCoursesSB: TScrollBox;
    PCourseSubjects: TPanel;
    PCourseSubjectsSB: TScrollBox;
    PCourseModules: TPanel;
    PCourseModulesSB: TScrollBox;
    PStudentsSB: TScrollBox;
    PStudents: TPanel;
    PStudentsCombo: TPanel;
    PButtons: TPanel;
    RxDBColorBox1: TRxDBColorBox;
    RxDBColorBox2: TRxDBColorBox;
    RxDBDateEdit1: TRxDBDateEdit;
    RxDBDateEdit2: TRxDBDateEdit;
    GridStudents: TRxDBGrid;
    GridCourseModules: TRxDBGrid;
    RxDBDateEdit3: TRxDBDateEdit;
    RxDBDateEdit4: TRxDBDateEdit;
    LookupComboCourses: TRxDBLookupCombo;
    RxDBDateEdit5: TRxDBDateEdit;
    RxDBSpinEdit3: TRxDBSpinEdit;
    RxDBSpinEdit4: TRxDBSpinEdit;
    PTeachersSB: TScrollBox;
    STeachers: TSplitter;
    SStudents: TSplitter;
    SCourses1: TSplitter;
    SCourses2: TSplitter;
    TabCourses: TTabSheet;
    TabTeachers: TTabSheet;
    TabStudents: TTabSheet;
    UpDownCourses: TUpDown;
    UpDownSubjects: TUpDown;
    UpDownModules: TUpDown;
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
    procedure PasteImageClick(Sender: TObject);
    procedure ClearImageClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BSaveAllClick(Sender: TObject);
    procedure PageCoursesChange(Sender: TObject);
    procedure PageCoursesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure PanelEnter(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
  private
    OnTable: TZTable;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

procedure TFrameCourses.PageCoursesChange(Sender: TObject);
begin
  BOK.Visible := true;
  BCancel.Visible := true;
  if PageCourses.ActivePage = TabCourses then begin
    Data.ZSubjects.Refresh;
    Data.ZUnlinkedModules.Refresh;
    Data.ZCourses.Refresh;
    Data.ZCourseSubjects.Refresh;
    Data.ZCourseModules.Refresh;
    PCourses.SetFocus;
  end
  else if PageCourses.ActivePage = TabStudents then begin
    LookupComboCourses.KeyValue := Data.ZCourses.FieldByName('id').AsString;
    PStudents.SetFocus;
  end
  else if PageCourses.ActivePage = TabTeachers then GridTeachers.SetFocus;
end;

procedure TFrameCourses.PageCoursesChanging(Sender: TObject;//Será necessário? E se for só na destruição do PageCourses?
  var AllowChange: Boolean);
begin
  if Data.onTransaction then begin
    if Application.MessageBox('Save Changes?', 'Pending Changes', MB_ICONQUESTION + MB_YESNO) = IDYES then Data.ZConnection.Commit
    else Data.ZConnection.Rollback;
  end;
end;

procedure TFrameCourses.PanelEnter(Sender: TObject);
begin
  if Sender = PCourses then OnTable := Data.ZCourses
  else if Sender = PCourseSubjects then OnTable := Data.ZCourseSubjects
  else if Sender = PCourseModules then OnTable := Data.ZCourseModules
  else if Sender = PStudents then OnTable := Data.ZStudents
  else if Sender = GridTeachers then OnTable := Data.ZTeachers;
end;
{
procedure TFrameCourses.RxDBDateEditEditingDone(Sender: TObject);
begin
  (Sender as TRxDBDateEdit).DataSource.Edit;
end;

procedure TFrameCourses.RxDBDateEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  (Sender as TRxDBDateEdit).DataSource.Edit;
end;
}
procedure TFrameCourses.UpDownClick(Sender: TObject; Button: TUDBtnType);
  var Table: TZTable;
begin
  if Sender = UpDownCourses then Table := Data.ZCourses
  else if Sender = UpDownSubjects then Table := Data.ZCourseSubjects
  else Table := Data.ZCourseModules;

  try
    Data.TableReorder(Table);
    With Table do begin
      if Button = btNext then begin
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
    Data.ZCourses.Cancel;
  end;
end;

procedure TFrameCourses.BOKClick(Sender: TObject);
  var Table: TZTable;
begin
  Table := nil;
  //if Data.ZSubjects.State in [dsEdit, dsInsert] then Table := Data.ZSubjects
  //else if Data.ZModules.State in [dsEdit, dsInsert] then Table := Data.ZModules
  if Data.ZCourses.State in [dsEdit, dsInsert] then Table := Data.ZCourses
  else if Data.ZCourseSubjects.State in [dsEdit, dsInsert] then Table := Data.ZCourseSubjects
  else if Data.ZCourseModules.State in [dsEdit, dsInsert] then Table := Data.ZCourseModules
  else if Data.ZStudents.State in [dsEdit, dsInsert] then Table := Data.ZStudents
  else if Data.ZTeachers.State in [dsEdit, dsInsert] then Table := Data.ZTeachers;
  //else if Data.ZPlanning.State in [dsEdit, dsInsert] then Table := Data.ZPlanning
  //else if Data.ZPlanningMaterials.State in [dsEdit, dsInsert] then Table := Data.ZPlanningMaterials;
  if Assigned(Table) then Table.Post
  else OnTable.Append;
end;

procedure TFrameCourses.BSaveAllClick(Sender: TObject);
begin
  Data.ZConnection.Commit;
  //RefreshCombo;
end;

procedure TFrameCourses.BCancelClick(Sender: TObject);
  var Table: TZTable;
begin
  Table := nil;
  //if Data.ZSubjects.State in [dsEdit, dsInsert] then Table := Data.ZSubjects
  //else if Data.ZModules.State in [dsEdit, dsInsert] then Table := Data.ZModules
  if Data.ZCourses.State in [dsEdit, dsInsert] then Table := Data.ZCourses
  else if Data.ZCourseSubjects.State in [dsEdit, dsInsert] then Table := Data.ZCourseSubjects
  else if Data.ZCourseModules.State in [dsEdit, dsInsert] then Table := Data.ZCourseModules
  else if Data.ZStudents.State in [dsEdit, dsInsert] then Table := Data.ZStudents
  else if Data.ZTeachers.State in [dsEdit, dsInsert] then Table := Data.ZTeachers;
  //else if Data.ZPlanning.State in [dsEdit, dsInsert] then Table := Data.ZPlanning
  //else if Data.ZPlanningMaterials.State in [dsEdit, dsInsert] then Table := Data.ZPlanningMaterials;
  if Assigned(Table) then Table.Cancel
  else begin
    if OnTable.RecordCount > 0 then begin
      OnTable.Delete;
      Data.TableReorder(OnTable);
      OnTable.Refresh;
    end;
  end;
end;
{
procedure TFrameCourses.PageCoursesMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := true;
end;
}
procedure TFrameCourses.PasteImageClick(Sender: TObject);
  var Jpg, Jpgs: TJPEGImage;
    w, h: Integer;
begin
  Jpg := TJPEGImage.Create;
  Jpgs := TJPEGImage.Create;
  Jpgs.SetSize(350, 450);
  Jpg.Assign(Clipboard);
  w := Min(Jpg.Width, round(Jpg.Height * 0.778));
  h := Min(Jpg.Height, round(Jpg.Width / 0.778));
  Jpg.Canvas.CopyRect(Rect(0, 0, w, h),Jpg.Canvas, Rect((Jpg.Width - w) div 2, (Jpg.Height - h) div 2, (Jpg.Width + w) div 2, (Jpg.Height + h) div 2));
  Jpg.SetSize(w, h);
  Jpgs.Canvas.StretchDraw(Rect(0, 0, 350, 450), Jpg);
  if Sender = BPasteImageT then begin
    Data.ZTeachers.Edit;
    DBImageT.Picture.Assign(Jpgs);
    Data.ZTeachers.Post;
  end
  else begin
    Data.ZStudents.Edit;
    DBImageS.Picture.Assign(Jpgs);
    Data.ZStudents.Post;
  end;
  Jpg.Free;
  Jpgs.Free;
end;

procedure TFrameCourses.ClearImageClick(Sender: TObject);
begin
  if Sender = BClearImageT then begin
    Data.ZTeachers.Edit;
    DBImageT.Picture.Clear;
    Data.ZTeachers.Post;
  end
  else begin
    Data.ZStudents.Edit;
    DBImageS.Picture.Clear;
    Data.ZStudents.Post;
  end;
end;

procedure TFrameCourses.BCancelAllClick(Sender: TObject);
begin
  Data.ZConnection.Rollback;
  //if Data.ZSubjects.Active then Data.ZSubjects.Refresh;
  //if Data.ZModules.Active then Data.ZModules.Refresh;
  if Data.ZCourses.Active then Data.ZCourses.Refresh;
  if Data.ZCourseSubjects.Active then Data.ZCourseSubjects.Refresh;
  if Data.ZCourseModules.Active then Data.ZCourseModules.Refresh;
  if Data.ZStudents.Active then Data.ZStudents.Refresh;
  if Data.ZTeachers.Active then Data.ZTeachers.Refresh;
  //if Data.ZPlanning.Active then Data.ZPlanning.Refresh;
  //if Data.ZPlanningMaterials.Active then Data.ZPlanningMaterials.Refresh;
  //if Data.ZMethodology.Active then Data.ZMethodology.Refresh;
end;

constructor TFrameCourses.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Self.Parent := TWinControl(TheOwner);
  Self.Align := alClient;
  Self.BorderStyle:= bsNone;
  PageCourses.ActivePage := TabCourses;
  //Data.ZSubjects.Open;
  //Data.ZModules.Open;
  //Data.ZPlanning.MasterFields := 'id';
  //Data.ZPlanning.MasterSource := Data.DModules;
  //Data.ZPlanning.Open;
  //Data.ZMethodology.Open;
  //Data.ZPlanningMaterials.Open;
  //RefreshCombo;
  Data.ZUnlinkedModules.Open;
  Data.ZCourses.Filtered := false;
  Data.ZCourseSubjects.Filtered := false;
  Data.ZCourseModules.Filtered := false;
  Data.ZCourses.Open;
  Data.ZCourseSubjects.Open;
  Data.ZCourseModules.Open;
  Data.ZStudents.Filtered := false;
  Data.ZStudents.Open;
  Data.ZTeachers.Open;
  OnTable := Data.ZCourses;
  PageCoursesChange(nil);
end;

destructor TFrameCourses.Destroy;
begin
  //Data.ZPlanningMaterials.Close;
  //Data.ZPlanning.Close;
  //Data.ZMethodology.Close;
  Data.ZTeachers.Close;
  Data.ZStudents.Close;
  Data.ZCourseModules.Close;
  Data.ZCourseSubjects.Close;
  Data.ZCourses.Close;
  Data.ZUnlinkedModules.Close;
  //Data.ZModules.Close;
  //Data.ZSubjects.Close;
  OnTable := nil;
  OnTable.Free;
  inherited Destroy;
end;

end.

