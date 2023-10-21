# Intercomparison problem 7

xmax = 6000.001

[Mesh]
  uniform_refine = 1
  [base_mesh]
    type = FileMeshGenerator
    file = case7_3D_0.msh
  []
  [shale1]
    input = 'base_mesh'
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 52'
    top_right = '${xmax} 1 55'
  []
  [shale2]
    input = 'shale1'
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 85'
    top_right = '${xmax} 1 88'
  []
  [shale3]
    input = 'shale2'
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 118'
    top_right = '${xmax} 1 121'
  []
  [shale4]
    input = 'shale3'
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 151'
    top_right = '${xmax} 1 154'
  []
  [top]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'z=184'
    new_sideset_name = 'top'
    input = 'shale4'
  []
  [bottom]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'z=0'
    new_sideset_name = 'bottom'
    input = 'top'
  []
  [right_area]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x=${xmax}'
    new_sideset_name = 'right_area'
    input = 'bottom'
  []
  [injection_area]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x=0&z=22'
    new_sideset_name = 'injection_area'
    input = 'right_area'
  []
  [block_rename]
    type = RenameBlockGenerator
    input = 'injection_area'
    old_block = '0 1'
    new_block = 'sand shale'
  []
  coord_type = 'XYZ'
[]


[GlobalParams]
  PorousFlowDictator = 'dictator'
  gravity = '0 0 -9.81'
  temperature = temperature
  log_extension = false
[]

[AuxVariables]
  [pressure_liquid]
    order = CONSTANT
    family = MONOMIAL
  []
  [saturation_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [xnacl]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 0.032
  []
  [temperature]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 37
  []
[]

[AuxKernels]
  [pressure_liquid]
    type = ADPorousFlowPropertyAux
    variable = pressure_liquid
    property = pressure
    phase = 0
    execute_on = 'initial timestep_end'
  []
  [saturation_gas]
    type = ADPorousFlowPropertyAux
    variable = saturation_gas
    property = saturation
    phase = 1
    execute_on = 'initial timestep_end'
  []
[]

[Variables]
  [pgas]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [zi]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    scaling = 1e4
    initial_condition = 4.54104e-4
  []
[]

[ICs]
  [pgas]
    type = FunctionIC
    variable = pgas
    function = '(-1/81*z+11+22/81)*1e6'
  []
[]

[FVKernels]
  [mass0]
    type = FVPorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pgas
  []
  [flux0]
    type = FVPorousFlowAdvectiveFlux
    fluid_component = 0
    variable = pgas
  []
  [mass1]
    type = FVPorousFlowMassTimeDerivative
    fluid_component = 1
    variable = zi
  []
  [flux1]
    type = FVPorousFlowAdvectiveFlux
    fluid_component = 1
    variable = zi
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pgas zi'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc_sand]
    type = PorousFlowCapillaryPressureVG
    alpha = 2.793e-4
    m = 0.400
    sat_lr = 0.2
    pc_max = 1e7
    block = 'sand'
  []
  [fs_sand]
    type = PorousFlowBrineCO2
    brine_fp = brine
    co2_fp = co2
    capillary_pressure = pc_sand
  []
  [pc_shale]
    type = PorousFlowCapillaryPressureVG
    alpha = 1.613e-5
    m = 0.400
    sat_lr = 0.2
    pc_max = 1e7#125e6
    block = 'shale'
  []
  [fs_shale]
    type = PorousFlowBrineCO2
    brine_fp = brine
    co2_fp = co2
    capillary_pressure = pc_shale
  []
[]

[FluidProperties]
  [co2sw]
    type = CO2FluidProperties
  []
  [co2]
    type = TabulatedFluidProperties
    fp = co2sw
    fluid_property_file = case7_co2_fluid_properties.csv
  []
  [water]
    type = Water97FluidProperties
  []
  [watertab]
    type = TabulatedFluidProperties
    fp = water
    fluid_property_file = case7_water_fluid_properties.csv
  []
  [brine]
    type = BrineFluidProperties
    water_fp = watertab
  []
[]

[Materials]
  [temperature]
    type = ADPorousFlowTemperature
    temperature = temperature
  []
  [brineco2_sand]
    type = ADPorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    xnacl = 'xnacl'
    capillary_pressure = pc_sand
    fluid_state = fs_sand
    block = 'sand'
  []
  [brineco2_shale]
    type = ADPorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    xnacl = 'xnacl'
    capillary_pressure = pc_shale
    fluid_state = fs_shale
    block = 'shale'
  []
  [porosity_sand]
    type = ADPorousFlowPorosityConst
    porosity = 0.35
    block = 'sand'
  []
  [porosity_shale]
    type = ADPorousFlowPorosityConst
    porosity = 0.1025
    block = 'shale'
  []
  [permeability_sand]
    type = ADPorousFlowPermeabilityConst
    permeability = '3.0e-12 0 0 0 3.0e-12 0 0 0 3.0e-12'
    block = 'sand'
  []
  [permeability_shale]
    type = ADPorousFlowPermeabilityConst
    permeability = '1.0e-14 0 0 0 1.0e-14 0 0 0 1.0e-14'
    block = 'shale'
  []
  [relperm_water]
    type = ADPorousFlowRelativePermeabilityVG
    m = 0.400
    phase = 0
    s_res = 0.2
    sum_s_res = 0.25
  []
  [relperm_gas]
    type = ADPorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.05
    sum_s_res = 0.25
    nw_phase = true
    lambda = 2
  []
[]

[FVBCs]
  [right_zi]
    type = FVDirichletBC
    variable = zi
    boundary = 'right_area'
    value = 4.54104e-4
  []
  [right_pgas]
    type =  FVFunctionDirichletBC
    variable = pgas
    boundary = 'right_area'
    function = '(-1/81*z+11+22/81)*1e6'
  []
[]

[BCs]
  [co2_injection]
    type = PorousFlowSink
    boundary = injection_area
    variable = zi
    fluid_phase = 1
    flux_function = '-0.1585'
  []
[]


[Preconditioning]
  active = 'smp'
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -pc_asm_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres      asm         restrict      lu          NONZERO                   2 '
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 6.31152e7
  dtmax = 8.64e4
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_max_its = 15
  l_tol = 1e-5
  l_abs_tol = 1e-8
  line_search = none
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 100
    growth_factor = 1.5
  []
[]

[Outputs]
  print_linear_residuals = false
  perf_graph = false
  sync_times = '0 2.592e6 3.15576e7 6.31152e7'
  exodus = true
[]
