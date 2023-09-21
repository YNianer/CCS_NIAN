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
[]


[Problem]
  type = FEProblem
  coord_type = 'XYZ'
[]

[GlobalParams]
  PorousFlowDictator = 'dictator'
  gravity = '0 0 -9.81'
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
  [x1]
    order = CONSTANT
    family = MONOMIAL
  []
  [y0]
    order = CONSTANT
    family = MONOMIAL
  []
  [xnacl]
    initial_condition = 0.032
  []
  [temp]
    initial_condition = 37
  []
  [permeability]
    order = CONSTANT
    family = MONOMIAL
  []
  [relperm_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [relperm_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [pc]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [pressure_liquid]
    type = PorousFlowPropertyAux
    variable = pressure_liquid
    property = pressure
    phase = 0
    execute_on = 'timestep_end'
  []
  [saturation_gas]
    type = PorousFlowPropertyAux
    variable = saturation_gas
    property = saturation
    phase = 1
    execute_on = 'timestep_end'
  []
  [x1]
    type = PorousFlowPropertyAux
    variable = x1
    property = mass_fraction
    phase = 0
    fluid_component = 1
    execute_on = 'timestep_end'
  []
  [y0]
    type = PorousFlowPropertyAux
    variable = y0
    property = mass_fraction
    phase = 1
    fluid_component = 0
    execute_on = 'timestep_end'
  []
  [permeability]
    type = PorousFlowPropertyAux
    variable = permeability
    property = permeability
    row = 2
    column = 2
    execute_on = 'timestep_end'
  []
  [relperm_water]
    type = PorousFlowPropertyAux
    variable = relperm_water
    property = relperm
    phase = 0
    execute_on = 'timestep_end'
  []
  [relperm_gas]
    type = PorousFlowPropertyAux
    variable = relperm_gas
    property = relperm
    phase = 1
    execute_on = 'timestep_end'
  []
  [pc]
    type = PorousFlowPropertyAux
    variable = pc
    property = capillary_pressure
    execute_on = 'timestep_end'
  []
[]

[Variables]
  [pgas]
    #initial_condition = 1e6
  []
  [zi]
    initial_condition = 4.54104e-4
    scaling = 1e4
  []
[]

[ICs]
  [pgas]
    type = FunctionIC
    variable = pgas
    function = '(-1/81*z+11+22/81)*1e6'
  []
[]

[Kernels]
  [mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pgas
  []
  [flux0]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = pgas
  []
  [mass1]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = zi
  []
  [flux1]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    variable = zi
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pgas zi'
    number_fluid_phases = 2
    number_fluid_components = 3
  []
  [pc_sand]
    type = PorousFlowCapillaryPressureVG
    alpha = 2.793e-4
    m = 0.400
    sat_lr = 0.2
    pc_max = 1e7#7.2e6
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
    type = PorousFlowTemperature
    temperature = temp
  []
  [brineco2_sand]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    temperature = temp
    xnacl = 'xnacl'
    capillary_pressure = pc_sand
    fluid_state = fs_sand
    block = 'sand'
  []
  [brineco2_shale]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    temperature = temp
    xnacl = 'xnacl'
    capillary_pressure = pc_shale
    fluid_state = fs_shale
    block = 'shale'
  []
  [porosity_sand]
    type = PorousFlowPorosityConst
    porosity = 0.35
    block = 'sand'
  []
  [porosity_shale]
    type = PorousFlowPorosityConst
    porosity = 0.1025
    block = 'shale'
  []
  [permeability_sand]
    type = PorousFlowPermeabilityConst
    permeability = '3.0e-12 0 0 0 3.0e-12 0 0 0 3.0e-12'
    block = 'sand'
  []
  [permeability_shale]
    type = PorousFlowPermeabilityConst
    permeability = '1.0e-14 0 0 0 1.0e-14 0 0 0 1.0e-14'
    block = 'shale'
  []
  [relperm_water]
    type = PorousFlowRelativePermeabilityVG
    m = 0.400
    phase = 0
    s_res = 0.2
    sum_s_res = 0.25
  []
  [relperm_gas]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.05
    sum_s_res = 0.25
    nw_phase = true
    lambda = 2
  []
[]

[BCs]
  [right_zi]
    type = DirichletBC
    variable = zi
    boundary = 'right_area'
    value = 4.54104e-4
  []
  [right_pgas]
    type =  FunctionDirichletBC
    variable = pgas
    boundary = 'right_area'
    function = '(-1/81*z+11+22/81)*1e6'
  []
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
    petsc_options_iname = '-ksp_type -pc_type -pc_asm_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap  -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres      asm         restrict      lu          NONZERO                   2                1E-8       1E-1          15'
  []
  [smp1]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -snes_atol -snes_rtol'
    petsc_options_value = 'gmres bjacobi lu NONZERO 1e2 1e-5'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 6.31152e7
  dtmax = 8.64e4
  l_max_its = 1000
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
