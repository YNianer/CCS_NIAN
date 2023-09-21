[Mesh]
  [base_mesh]
    type = FileMeshGenerator
    file = spe11a.msh
  []
  [set_block_names]
    type = RenameBlockGenerator
    old_block = ' 1 2 3 4 5 6 7 '
    new_block = 'facies_1 facies_2 facies_3 facies_4 facies_5 facies_6 facies_7'
    input = base_mesh
  []
  [set_boundary_names]
    type = RenameBoundaryGenerator
    old_boundary = '319 320 321 322'
    new_boundary = 'bottom right left top'
    input = set_block_names
  []
[]

[Problem]
  type = FEProblem
  coord_type = 'XYZ'
[]

[GlobalParams]
  PorousFlowDictator = 'dictator'
  gravity = '0 -9.81 0'
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
[]

[Variables]
  [pgas]
    initial_condition = 1.1e5
  []
  [zi]
    initial_condition = 0
    scaling = 1e4
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
  [disp0]
    type = PorousFlowDispersiveFlux
    fluid_component = 0
    variable = pgas
    disp_long = '1e-2 1e-2'
    disp_trans = '1e-2 1e-2'
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
  [disp1]
    type = PorousFlowDispersiveFlux
    fluid_component = 1
    variable = zi
    disp_long = '1e-2 1e-2'
    disp_trans = '1e-2 1e-2'
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pgas zi'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc_1]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 1500
    block = 'facies_1'
  []
  [pc_2]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 300
    block = 'facies_2'
  []
  [pc_3]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 100
    block = 'facies_3'
  []
  [pc_4]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe =25
    block = 'facies_4'
  []
  [pc_5]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 10
    block = 'facies_5'
  []
  [pc_6]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 1
    block = 'facies_6'
  []
  [pc_7]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 1e-5
    block = 'facies_7'
  []
  [fs_1]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_1
  []
  [fs_2]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_2
  []
  [fs_3]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_3
  []
  [fs_4]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_4
  []
  [fs_5]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_5
  []
  [fs_6]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_6
  []
  [fs_7]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_7
  []
[]

[FluidProperties]
  [co2]
    type = CO2FluidProperties
  []
  [water]
    type = Water97FluidProperties
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = 20
  []
  [waterncg_1]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_1
    fluid_state = fs_1
    block = 'facies_1'
  []
  [waterncg_2]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_2
    fluid_state = fs_2
    block = 'facies_2'
  []
  [waterncg_3]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_3
    fluid_state = fs_3
    block = 'facies_3'
  []
  [waterncg_4]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_4
    fluid_state = fs_4
    block = 'facies_4'
  []
  [waterncg_5]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_5
    fluid_state = fs_5
    block = 'facies_5'
  []
  [waterncg_6]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_6
    fluid_state = fs_6
    block = 'facies_6'
  []
  [waterncg_7]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_7
    fluid_state = fs_7
    block = 'facies_7'
  []
  [diff_1]
    type = PorousFlowDiffusivityConst
    diffusion_coeff = '1e-9 1e-9 1.6e-5 1.6e-5'
    tortuosity = '1 1'
    block = 'facies_1 facies_2 facies_3 facies_4 facies_5 facies_6'
  []
  [diff_2]
    type = PorousFlowDiffusivityConst
    diffusion_coeff = '0 0 0 0'
    tortuosity = '1 1'
    block = 'facies_7'
  []
  [porosity_1]
    type = PorousFlowPorosityConst
    porosity = 0.44
    block = 'facies_1'
  []
  [porosity_2]
    type = PorousFlowPorosityConst
    porosity = 0.43
    block = 'facies_2'
  []
  [porosity_3]
    type = PorousFlowPorosityConst
    porosity = 0.44
    block = 'facies_3'
  []
  [porosity_4]
    type = PorousFlowPorosityConst
    porosity = 0.45
    block = 'facies_4'
  []
  [porosity_5]
    type = PorousFlowPorosityConst
    porosity = 0.43
    block = 'facies_5'
  []
  [porosity_6]
    type = PorousFlowPorosityConst
    porosity = 0.46
    block = 'facies_6'
  []
  [porosity_7]
    type = PorousFlowPorosityConst
    porosity = 0
    block = 'facies_7'
  []
  [permeability_1]
    type = PorousFlowPermeabilityConst
    permeability = '4e-11 0 0 0 4e-11 0 0 0 4e-11'
    block = 'facies_1'
  []
  [permeability_2]
    type = PorousFlowPermeabilityConst
    permeability = '5e-10 0 0 0 5e-10 0 0 0 5e-10'
    block = 'facies_2'
  []
  [permeability_3]
    type = PorousFlowPermeabilityConst
    permeability = '1e-9 0 0 0 1e-9 0 0 0 1e-9'
    block = 'facies_3'
  []
  [permeability_4]
    type = PorousFlowPermeabilityConst
    permeability = '2e-9 0 0 0 2e-9 0 0 0 2e-9'
    block = 'facies_4'
  []
  [permeability_5]
    type = PorousFlowPermeabilityConst
    permeability = '4e-9 0 0 0 4e-9 0 0 0 4e-9'
    block = 'facies_5'
  []
  [permeability_6]
    type = PorousFlowPermeabilityConst
    permeability = '1e-8 0 0 0 1e-8 0 0 0 1e-8'
    block = 'facies_6'
  []
  [permeability_7]
    type = PorousFlowPermeabilityConst
    permeability = '0 0 0 0 0 0 0 0 0'
    block = 'facies_7'
  []
  [relperm_water_1]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.32
    sum_s_res = 0.42
    nw_phase = false
    lambda = 2
    block = 'facies_1'
  []
  [relperm_gas_1]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.42
    nw_phase = false
    lambda = 2
    block = 'facies_1'
  []
  [relperm_water_2]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.14
    sum_s_res = 0.24
    nw_phase = false
    lambda = 2
    block = 'facies_2'
  []
  [relperm_gas_2]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.24
    nw_phase = false
    lambda = 2
    block = 'facies_2'
  []
  [relperm_water_3]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_3'
  []
  [relperm_gas_3]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_3'
  []
  [relperm_water_4]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_4'
  []
  [relperm_gas_4]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_4'
  []
  [relperm_water_5]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_5'
  []
  [relperm_gas_5]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.22
    nw_phase = false
    lambda = 2
    block = 'facies_5'
  []
  [relperm_water_6]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.1
    sum_s_res = 0.2
    nw_phase = false
    lambda = 2
    block = 'facies_6'
  []
  [relperm_gas_6]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.2
    nw_phase = false
    lambda = 2
    block = 'facies_6'
  []
  [relperm_water_7]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0
    sum_s_res = 0.1
    nw_phase = false
    lambda = 2
    block = 'facies_7'
  []
  [relperm_gas_7]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.1
    nw_phase = false
    lambda = 2
    block = 'facies_7'
  []
[]

[BCs]
  [top_pressure_fixed]
    type = DirichletBC
    boundary = top
    value = 1.1e5
    variable = pgas
  []
  [top_zi_fixed]
    type = DirichletBC
    boundary = top
    value = 0
    variable = zi
  []
[]


[DiracKernels]
  [source1]
    type = PorousFlowSquarePulsePointSource
    point = '0.9 0.3 0'
    mass_flux = 1.7e-5
    variable = zi
    start_time = 0
    end_time = 18000
  []
  [source2]
    type = PorousFlowSquarePulsePointSource
    point = '1.7 0.7 0'
    mass_flux = 1.7e-5
    variable = zi
    start_time = 9000
    end_time = 18000
  []
[]


[Preconditioning]
  active = 'smp'
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -pc_asm_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap  -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres      asm         restrict      lu          NONZERO                   2                1E-4       1E-10          15'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 4.32e5
  dtmax = 60
  l_max_its = 1000
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    growth_factor = 1.5
  []
[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  sync_times = '0 8.640e4 1.728e5 2.592e5 3.456e5 4.32e5'
  exodus = true
[]
