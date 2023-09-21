# Intercomparison problem 7

### barrier block_27
### ESF     block_0   block_10  block_20
### C       block_1   block_21
### D       block_2   block_22
### E       block_3   block_13  block_23
### F       block_4   block_14  block_24  block_34
### G       block_5   blocl_6   block_8   block_15  block_26  block_35

### box_A   block_10  block_13  block_14  block_15  block_34  block_35
### box_B   block_20  block_21  block_22  block_23  block_24  block_26  block_27
### box_C   block_34  block_35

[Mesh]
  [base_mesh]
    type = FileMeshGenerator
    file = fluidflower_uniform_mesh.e
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
    initial_condition = 1e5
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
    number_fluid_components = 2
  []
  [pc_barrier]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 1e-5
    block = '27'
  []
  [pc_ESF]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 1471.5
    block = '0 10 20'
  []
  [pc_C]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 294.3
    block = '1 21'
  []
  [pc_D]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 98.1
    block = '2 22'
  [] 
  [pc_E]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 10
    block = '3 13 23'
  []  
  [pc_F]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 10
    block = '4 14 24 34'
  []  
  [pc_G]
    type = PorousFlowCapillaryPressureBC
    lambda = 2
    pe = 10
    block = '5 6 8 15 26 35'
  []
  [fs_barrier]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_barrier
  []
  [fs_ESF]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_ESF
  []
  [fs_C]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_C
  []
  [fs_D]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_D
  []
  [fs_E]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_E
  []
  [fs_F]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_F
  []
  [fs_G]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc_G
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
  [waterncg_barrier]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_barrier
    fluid_state = fs_barrier
    block = '27'
  []
  [waterncg_ESF]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_ESF
    fluid_state = fs_ESF
    block = '0 10 20'
  []
  [waterncg_C]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_C
    fluid_state = fs_C
    block = '1 21'
  []
  [waterncg_D]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_D
    fluid_state = fs_D
    block = '2 22'
  []
  [waterncg_E]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_E
    fluid_state = fs_E
    block = '3 13 23'
  []
  [waterncg_F]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_F
    fluid_state = fs_F
    block = '4 14 24 34'
  []
  [waterncg_G]
    type = PorousFlowFluidState
    gas_porepressure = 'pgas'
    z = 'zi'
    temperature_unit = Celsius
    capillary_pressure = pc_G
    fluid_state = fs_G
    block = '5 6 8 15 26 35'
  []
  [porosity_barrier]
    type = PorousFlowPorosityConst
    porosity = 0.1
    block = '27'
  []
  [porosity_ESF]
    type = PorousFlowPorosityConst
    porosity = 0.43
    block = '0 10 20'
  []
  [porosity_C]
    type = PorousFlowPorosityConst
    porosity = 0.44
    block = '1 21'
  []
  [porosity_D]
    type = PorousFlowPorosityConst
    porosity = 0.44
    block = '2 22'
  []
  [porosity_E]
    type = PorousFlowPorosityConst
    porosity = 0.45
    block = '3 13 23'
  []
  [porosity_F]
    type = PorousFlowPorosityConst
    porosity = 0.45
    block = '4 14 24 34'
  []
  [porosity_G]
    type = PorousFlowPorosityConst
    porosity = 0.44
    block = '5 6 8 15 26 35'
  []
  [permeability_barrier]
    type = PorousFlowPermeabilityConst
    permeability = '0 0 0 0 0 0 0 0 0'
    block = '27'
  []
  [permeability_ESF]
    type = PorousFlowPermeabilityConst
    permeability = '5.70e-11 0 0 0 5.70e-11 0 0 0 5.70e-11'
    block = '0 10 20'
  []
  [permeability_C]
    type = PorousFlowPermeabilityConst
    permeability = '4.68e-10 0 0 0 4.68e-10 0 0 0 4.68e-10'
    block = '1 21'
  []
  [permeability_D]
    type = PorousFlowPermeabilityConst
    permeability = '1.08e-9 0 0 0 1.08e-9 0 0 0 1.08e-9'
    block = '2 22'
  []
  [permeability_E]
    type = PorousFlowPermeabilityConst
    permeability = '2.52e-9 0 0 0 2.52e-9 0 0 0 2.52e-9'
    block = '3 13 23'
  []
  [permeability_F]
    type = PorousFlowPermeabilityConst
    permeability = '4.12e-9 0 0 0 4.12e-9 0 0 0 4.12e-9'
    block = '4 14 24 34'
  []
  [permeability_G]
    type = PorousFlowPermeabilityConst
    permeability = '4.10e-9 0 0 0 4.10e-9 0 0 0 4.10e-9'
    block = '5 6 8 15 26 35'
  []
  [relperm_water_barrier]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.05
    sum_s_res = 0.05
    nw_phase = false
    lambda = 2
    block = '27'
  []
  [relperm_gas_barrier]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0
    sum_s_res = 0.05
    nw_phase = true
    lambda = 2
    block = '27'
  []
  [relperm_water_ESF]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.32
    sum_s_res = 0.46
    nw_phase = false
    lambda = 2
    block = '0 10 20'
  []
  [relperm_gas_ESF]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.14
    sum_s_res = 0.46
    nw_phase = true
    lambda = 2
    block = '0 10 20'
  []
  [relperm_water_C]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.14
    sum_s_res = 0.24
    nw_phase = false
    lambda = 2
    block = '1 21'
  []
  [relperm_gas_C]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.1
    sum_s_res = 0.24
    nw_phase = true
    lambda = 2
    block = '1 21'
  []
  [relperm_water_D]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.20
    nw_phase = false
    lambda = 2
    block = '2 22'
  []
  [relperm_gas_D]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.08
    sum_s_res = 0.20
    nw_phase = true
    lambda = 2
    block = '2 22'
  []
  [relperm_water_E]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.18
    nw_phase = false
    lambda = 2
    block = '3 13 23'
  []
  [relperm_gas_E]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.06
    sum_s_res = 0.18
    nw_phase = true
    lambda = 2
    block = '3 13 23'
  []
  [relperm_water_F]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.12
    sum_s_res = 0.25
    nw_phase = false
    lambda = 2
    block = '4 14 24 34'
  []
  [relperm_gas_F]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.13
    sum_s_res = 0.25
    nw_phase = true
    lambda = 2
    block = '4 14 24 34'
  []
  [relperm_water_G]
    type = PorousFlowRelativePermeabilityBC
    phase = 0
    s_res = 0.1
    sum_s_res = 0.16
    nw_phase = false
    lambda = 2
    block = '5 6 8 15 26 35'
  []
  [relperm_gas_G]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.06
    sum_s_res = 0.16
    nw_phase = true
    lambda = 2
    block = '5 6 8 15 26 35'
  []
[]

[BCs]
  [top_pressure_fixed]
    type = DirichletBC
    boundary = top
    value = 1e5
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
    mass_flux = 3.3283e-7   # 10 ml/min = (1.997 g/L) * (10 * 1e-3 L/min) = 1.997e-2 g/min = 1.997e-2 * 1e-3 / 60 kg/s
    variable = zi
    start_time = 0
    end_time = 18000
  []
  [source2]
    type = PorousFlowSquarePulsePointSource
    point = '1.7 0.7 0'
    mass_flux = 3.3283e-7
    variable = zi
    start_time = 8100
    end_time = 18000
  []
[]

[Preconditioning]
  active = 'smp'
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -pc_asm_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap  -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres      asm         restrict      lu          NONZERO                   2                1E-8       1E-5          15'
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
  sync_times = '8.640e4 1.728e5 2.592e5 3.456e5 4.32e5'
  exodus = true
[]
