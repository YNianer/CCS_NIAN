//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "CCS_NIANTestApp.h"
#include "CCS_NIANApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
CCS_NIANTestApp::validParams()
{
  InputParameters params = CCS_NIANApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

CCS_NIANTestApp::CCS_NIANTestApp(InputParameters parameters) : MooseApp(parameters)
{
  CCS_NIANTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

CCS_NIANTestApp::~CCS_NIANTestApp() {}

void
CCS_NIANTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  CCS_NIANApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"CCS_NIANTestApp"});
    Registry::registerActionsTo(af, {"CCS_NIANTestApp"});
  }
}

void
CCS_NIANTestApp::registerApps()
{
  registerApp(CCS_NIANApp);
  registerApp(CCS_NIANTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
CCS_NIANTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  CCS_NIANTestApp::registerAll(f, af, s);
}
extern "C" void
CCS_NIANTestApp__registerApps()
{
  CCS_NIANTestApp::registerApps();
}
