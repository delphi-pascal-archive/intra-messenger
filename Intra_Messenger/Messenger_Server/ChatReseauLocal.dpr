program ChatReseauLocal;

uses
  Forms,
  UnitChatRL in 'UnitChatRL.pas' {ChatRL};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TChatRL, ChatRL);
  Application.Run;
end.
