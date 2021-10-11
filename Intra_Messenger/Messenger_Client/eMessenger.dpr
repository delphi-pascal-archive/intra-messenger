program eMessenger;

uses
  Forms,
  UnitChatRL in 'UnitChatRL.pas' {ChatRL},
  ChoixCouleurPanel in 'ChoixCouleurPanel.pas' {ChoixCouleur},
  AlertMsg in 'AlertMsg.pas' {AlertMsgF},
  AudioVideo in 'AudioVideo.pas' {CAudioVideo},
  Unit_MsgPerso in 'Unit_MsgPerso.pas' {MsgPerso};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TChatRL, ChatRL);
  Application.CreateForm(TAlertMsgF, AlertMsgF);
  Application.CreateForm(TMsgPerso, MsgPerso);
  Application.Run;
end.
