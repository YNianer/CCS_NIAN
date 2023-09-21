#include "CCS_NIANApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
CCS_NIANApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

CCS_NIANApp::CCS_NIANApp(InputParameters parameters) : MooseApp(parameters)
{
  CCS_NIANApp::registerAll(_factory, _action_factory, _syntax);
}

CCS_NIANApp::~CCS_NIANApp() {}

void 
CCS_NIANApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<CCS_NIANApp>(f, af, s);
  Registry::registerObjectsTo(f, {"CCS_NIANApp"});
  Registry::registerActionsTo(af, {"CCS_NIANApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
CCS_NIANApp::registerApps()
{
  registerApp(CCS_NIANApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
CCS_NIANApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  CCS_NIANApp::registerAll(f, af, s);
}
extern "C" void
CCS_NIANApp__registerApps()
{
  CCS_NIANApp::registerApps();
}
