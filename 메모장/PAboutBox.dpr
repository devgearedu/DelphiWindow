library PAboutBox;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }



{$R *.dres}

uses
  System.SysUtils,
  System.Classes,
  uAbout in 'uAbout.pas' {AboutBox};

{$R *.res}

{$R <PropertyGroup Condition="'$(Base)'!=''"> <VCL_Custom_Styles>&quot;Windows10 purple|VCLSTYLE|$(PUBLIC)\Documents\Embarcadero\Studio\20.0\Styles\Windows10purple.vsf&quot;</VCL_Custom_Styles>}
exports
   Display_About,
   Add,
   Sub,
   Divide;

begin
end.
