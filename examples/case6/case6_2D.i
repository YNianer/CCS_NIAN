[Mesh]
  [base_mesh]
    type = FileMeshGenerator
    file = case6_2D.msh
  []
  [Caprock]
    input = 'base_mesh'
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 200'
    top_right = '2000.002 0 300'
  []
  [top]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'z>1500'
    new_sideset_name = 'top'
    input = 'Caprock'
  []
  [bottom]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'z<1'
    new_sideset_name = 'bottom'
    input = 'top'
  []
  [left]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x<0.001'
    new_sideset_name = 'left'
    input = 'bottom'
  []
  [right]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>2000.001'
    new_sideset_name = 'right'
    input = 'left'
  []
  [injection_area]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x=1000.001&z<1'
    new_sideset_name = 'injection_area'
    input = 'right'
  []
  [block_rename]
    type = RenameBlockGenerator
    input = 'injection_area'
    old_block = '0 1'
    new_block = 'Aquifer Caprock'
  []
[]

[Problem]
  coord_type = XYZ
[]

[GlobalParams]
  displacements = 'disp_x disp_z'
  PorousFlowDictator = dictator
  gravity = '0 0 -9.81'
  biot_coefficient = 1.0
[]

[Variables]
  [pwater]
  []
  [sgas]
    initial_condition = 0.0
  []
  [temp]
  []
  [disp_z]
  []
[]

[ICs]
  [pwater]
    type = FunctionIC
    variable = pwater
    function = '15.1e6+10 - 0.01*z*1e6'# 0m 0.1mpa -1500m 15.1mpa
  []
  [temp]
    type = FunctionIC
    variable = temp
    function = '47.5 - 0.025*z + 273.15' # 0m 10c -1500m 47.5c
  []
[]

[AuxVariables]
  [disp_x]
  []
  [ref_temp]
    family = MONOMIAL
    order = CONSTANT
  []
  [mean_effective_stress]
    family = MONOMIAL
    order = CONSTANT
  []
  [porosity_cap]
    family = MONOMIAL
    order = CONSTANT
  []
  [porosity_aqu]
    family = MONOMIAL
    order = CONSTANT
  []
  [massfrac_ph0_sp0]
    initial_condition = 1 # all H20 in phase=0
  []
  [massfrac_ph1_sp0]
    initial_condition = 0 # no H2O in phase=1
  []
  [pgas]
    family = MONOMIAL
    order = CONSTANT
  []
  [swater]
    family = MONOMIAL
    order = CONSTANT
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [porosity]
    family = MONOMIAL
    order = CONSTANT
  []
  [rhowater]
    family = MONOMIAL
    order = CONSTANT
  []
  [rhogas]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [mass_water_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pwater
  []
  [flux_water]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    use_displaced_mesh = false
    variable = pwater
  []
  [mass_co2_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = sgas
  []
  [flux_co2]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    use_displaced_mesh = false
    variable = sgas
  []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = temp
  []
  [advection]
    type = PorousFlowHeatAdvection
    use_displaced_mesh = false
    variable = temp
  []
  [conduction]  
    type = PorousFlowHeatConduction
    use_displaced_mesh = false
    variable = temp
  []
  [grad_stress_y] # grad(sigma)
    type = StressDivergenceTensors
    temperature = temp
    eigenstrain_names = thermal_contribution
    variable = disp_z
    use_displaced_mesh = false
    component = 1
  []
  [poro_y]   # alpha_biot * grad(P_f)
    type = PorousFlowEffectiveStressCoupling
    variable = disp_z
    use_displaced_mesh = false
    component = 1
  []
  [gravity_y] # density*g
    type = Gravity
    variable = disp_z
    value = -9.81
    density = rho_mat
    use_displaced_mesh = false
  []
[]

[AuxKernels]
  [mean_effective_stress]
    type = ParsedAux
    coupled_variables = 'stress_xx stress_yy stress_zz pwater pgas swater sgas'
    expression = '1/3*(stress_xx + stress_yy + stress_zz) + (pwater * swater + pgas * sgas)'
    variable = mean_effective_stress
  []
  [porosity_aqu]
    type = ParsedAux
    coupled_variables = 'mean_effective_stress'
    expression = '(0.1 - 0.09)*exp(5e-8*-mean_effective_stress) + 0.09'
    variable = porosity_aqu
  []
  [porosity_cap]
    type = ParsedAux
    coupled_variables = 'mean_effective_stress'
    expression = '(0.01 - 0.009)*exp(5e-8*mean_effective_stress) + 0.009'
    variable = porosity_cap
  []
  [ref_temp]
    type = FunctionAux
    function = '47.5 - 0.025*z + 273.15'
    variable = ref_temp
  []
  [pgas]
    type = PorousFlowPropertyAux
    property = pressure
    phase = 1
    variable = pgas
  []
  [swater]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 0
    variable = swater
  []
  [stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  []
  [stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  []
  [stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  []
  [porosity]
    type = PorousFlowPropertyAux
    variable = porosity
    property = porosity
  []
  [rhowater]
    type = PorousFlowPropertyAux
    property = density
    phase = 0
    variable = rhowater
  []
  [rhogas]
    type = PorousFlowPropertyAux
    property = density
    phase = 1
    variable = rhogas
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'temp pwater sgas disp_z'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc_aqu]
    type = PorousFlowCapillaryPressureVG
    alpha = 5.1020e-5 # 1/19.6kpa
    m = 0.457
    sat_lr = 0.0
    pc_max = 1e7
    block = 'Aquifer'
  []
  [pc_cap]
    type = PorousFlowCapillaryPressureVG
    alpha = 3.2258e-7 # 1/3100kpa
    m = 0.457
    sat_lr = 0.0
    pc_max = 1e7
    block = 'Caprock'
  []
[]

[FluidProperties]
  [true_water]
    type = Water97FluidProperties
  []
  [tabulated_water]
    type = TabulatedFluidProperties
    fp = true_water
    temperature_min = 275
    pressure_max = 1E8
    fluid_property_file = water97_tabulated_11.csv
  []
  [true_co2]
    type = CO2FluidProperties
  []
  [tabulated_co2]
    type = TabulatedFluidProperties
    fp = true_co2
    temperature_min = 275
    pressure_max = 1E8
    fluid_property_file = co2_tabulated_11.csv
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temp
  []
  [ppss_aqu]
    type = PorousFlow2PhasePS
    phase0_porepressure = pwater
    phase1_saturation = sgas
    capillary_pressure = pc_aqu
    block = 'Aquifer'
  []
  [ppss_cap]
    type = PorousFlow2PhasePS
    phase0_porepressure = pwater
    phase1_saturation = sgas
    capillary_pressure = pc_cap
    block = 'Caprock'
  []
  [massfrac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'massfrac_ph0_sp0 massfrac_ph1_sp0'
  []
  [water]
    type = PorousFlowSingleComponentFluid
    fp = tabulated_water
    phase = 0
  []
  [gas]
    type = PorousFlowSingleComponentFluid
    fp = tabulated_co2
    phase = 1
  []
  [porosity_reservoir_aqu]
    type = PorousFlowPorosityConst
    porosity = 0.1 #porosity_aqu
    block = 'Aquifer'
  []
  [porosity_reservoir_cap]
    type = PorousFlowPorosityConst
    porosity = 0.01 #porosity_cap
    block = 'Caprock'
  []
  [permeability_reservoir_aqu]
    type = PorousFlowPermeabilityExponential
    poroperm_function = 'exp_k'
    k_anisotropy = '1e-13 0 0  0 1e-13 0  0 0 1e-13'
    A = 222
    B = 2.284e-10
    block = 'Aquifer'
  []
  [permeability_reservoir_cap]
    type = PorousFlowPermeabilityExponential
    poroperm_function = 'exp_k'
    k_anisotropy = '1e-17 0 0  0 1e-17 0  0 0 1e-17'
    A = 2220
    B = 2.284e-10
    block = 'Caprock'
  []
  [relperm_liquid]
    type = PorousFlowRelativePermeabilityCorey
    n = 4
    phase = 0
    s_res = 0.3
    sum_s_res = 0.35
  []
  [relperm_gas]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.05
    sum_s_res = 0.35
    nw_phase = true
    lambda = 2
  []
  [thermal_conductivity_reservoir]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1.320 0 0  0 1.320 0  0 0 1.320'
    wet_thermal_conductivity = '3.083 0 0  0 3.083 0  0 0 3.083'
  []
  [internal_energy_reservoir]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 1100
    density = 2260.0
  []
  [elasticity_tensor] #C_ijkl
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 5.0E9 # pa
    poissons_ratio = 0.25
  []
  [strain] # epsilon_T + epsilon_0 
    type = ComputeSmallStrain
    eigenstrain_names = 'thermal_contribution ini_stress'
  []
  [ini_strain] # epsilon_0
    type = ComputeEigenstrainFromInitialStress
    initial_stress = 'sigma_x 0 0  0 sigma_x 0  0 0 sigma_z'
    eigenstrain_name = ini_stress
  []
  [thermal_contribution] # alpha_t * (T - T_ref) * I
    type = ComputeThermalExpansionEigenstrain
    temperature = temp
    stress_free_temperature = ref_temp
    thermal_expansion_coeff = 5e-6
    eigenstrain_name = thermal_contribution
  []
  [stress] # sigama_tot = C_ijkl*epsilon_tot
    type = ComputeLinearElasticStress
  []
  [eff_fluid_pressure] # sigma_eff = sigma_tot + alpha_b * P_f * I
    type = PorousFlowEffectiveFluidPressure
  []
  [vol_strain]
    type = PorousFlowVolumetricStrain
  []
  [rho_mat]
    type =  ParsedMaterial
    property_name = rho_mat
    coupled_variables = 'porosity sgas swater rhowater rhogas'
    expression = '(1-porosity)*2260 + porosity*(sgas*rhogas+swater*rhowater)'
  []
[]

[Functions]
  [sigma_x]
    type = ParsedFunction
    expression = '0.6*(-33.3E6 + 22.2E3*z)'
  []
  [sigma_z]
    type = ParsedFunction
    expression = '-33.3E6 + 22.2E3*z'
  []
[]

[BCs]
  [top_pressure_fixed]
    type = FunctionDirichletBC
    boundary = 'top'
    function = '1e5'
    variable = pwater
    use_displaced_mesh = false
  []
  [top_saturation_fixed]
    type = DirichletBC
    boundary = top
    value = 0.0
    variable = sgas
    use_displaced_mesh = false
  []
  [top_temp_fixed]
    type = DirichletBC
    boundary = top
    value = 283.15
    variable = temp
    use_displaced_mesh = false
  []
  [top_dispy_fixed]
    type = DirichletBC
    boundary = 'left right'
    value = 0
    variable = disp_z
    use_displaced_mesh = false
  []
  [bottom_dispy_fixed]
    type = Pressure
    boundary = injection_area
    variable = disp_z
    component = 1 
    postprocessor = p_bh # note, this lags
    use_displaced_mesh = false
  []
  [co2_injection]
    type = PorousFlowSink
    boundary = injection_area
    variable = sgas
    fluid_phase = 1
    flux_function = '-0.05'
    use_displaced_mesh = false
  []
[]


[Postprocessors]
  [p_bh]
    type = PointValue
    variable = pwater
    point = '1000.001 0 0'
    execute_on = timestep_begin
    use_displaced_mesh = false
  []
[]

[Preconditioning]
  active = 'smp'
  [smp]
    type = SMP
    full = true
    #petsc_options = '-snes_converged_reason -ksp_diagonal_scale -ksp_diagonal_scale_fix -ksp_gmres_modifiedgramschmidt -snes_linesearch_monitor'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres      asm      lu           NONZERO                   2               1E2       1E-5        15'
  []
  [mumps]
    type = SMP
    full = true
    petsc_options = '-snes_converged_reason -ksp_diagonal_scale -ksp_diagonal_scale_fix -ksp_gmres_modifiedgramschmidt -snes_linesearch_monitor'
    petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package -pc_factor_shift_type -snes_rtol -snes_atol -snes_max_it'
    petsc_options_value = 'gmres      lu       mumps                         NONZERO               1E-5       1E2       50'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time =  9.45e7# 3.1536E7
  dtmax = 1e6
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 100
    growth_factor = 1.5
  []
[]

[Outputs]
  print_linear_residuals = false
  sync_times = '3600 86400 2.592E6 3.1536E7' # 1h 1day 1month 1year 5years 
  perf_graph = true
  exodus = true
  [csv]
    type = CSV
    sync_only = true
  []
[]
