program report_02_01
  use mds

  implicit none

  !Parameters.
  double precision, parameter :: density=0.7d0
  integer, parameter :: N=125
  logical, parameter :: bc=.true.

  !Variables.
  character(len=:), allocatable :: integrator

  double precision, dimension(N, 3) :: F, r, v
  double precision :: avg_T, dt, ins_T, K, L, momentum, random, rc, &
    temperature, time, U

  integer, dimension(:), allocatable :: seed
  integer :: i, j, M, s, t, time_steps

  logical :: switch=.false.

  real :: t1, t2

  open(unit=1, file="../data/velocity_distribution.dat")
  open(unit=2, file="../data/thermodynamics_01_01.dat")

  !We fix the seed for reproducibility.
  call random_seed(size=s)
  allocate(seed(s))
  seed = 0
  call random_seed(put=seed)
  deallocate(seed)

  call cpu_time(t1)

  !Integrator.
  integrator = 'Velocity Verlet'

  !Time step.
  dt = 1.0d-4

  if ((integrator == 'Velocity Verlet').and.(dt <= 1.0d-4)) switch = .true.

  !Size of the system given the density.
  L = (N/density)**(1/3.0d0)
  M = nint(N**(1/3.0d0))

  !Cutoff.
  rc = L / 4

  !Initial temperature.
  temperature = 100.0d0

  write(2, '(a)') '# ' // integrator // ' integrator.'
  write(2, '(a,es7.1)') '# dt=', dt
  write(2, '(a,a25,4(a26))') '#', 't', 'K', 'U', 'P', 'T'

  !Initial positions of the particles.
  r = 0.0d0
  call init_sc(r, L, M)

  !We apply pbc to center the lattice at (0, 0, 0).
  if (bc) then
    do i = 1, N
      r(i, :) = pbc(r(i, :), L)
    end do
  end if

  !Initial velocities of the particles: bimodal distribution.
  do i = 1, N
    do j = 1, 3
      call random_number(random)
      if (random < 0.5d0) then
        v(i, j) = +sqrt(temperature)
      else
        v(i, j) = -sqrt(temperature)
      end if
    end do
  end do

  if (switch) then
    write(1, '(a)') '# ' // integrator // ' integrator.'
    write(1, '(a,a25,2(a26))') '#', 'vx', 'vy', 'vz'

    !Initial distribution of the velocity components.
    do i = 1, N
      write(1, '(3(es26.16))') v(i, :)
    end do
    write(1, '(a)') achar(10)
  end if

  !Initial force and potential energy.
  call force(r, rc, L, bc, F, U)

  !Initialization of the average temperature.
  avg_T = 0.0d0

  !Molecular Dynamics Simulation.
  time = 0.0d0
  time_steps = 10000
  do t = 0, time_steps
    if (t > 0) then
      !We advance the time step.
      time = time + dt

      !We select the integrator.
      select case (integrator)
        case ('Velocity Verlet')
          call vel_verlet(r, v, F, U, dt, rc, L, bc)
        case ('Euler')
          call euler(r, v, U, dt, rc, L, bc)
      end select

      !We apply pbc.
      if (bc) then
        do i = 1, N
          r(i, :) = pbc(r(i, :), L)
        end do
      end if
    end if

    !Kinetic energy and instantaneous temperature.
    K = kin_energy(v)
    ins_T = K*2/3/N

    !Total momentum.
    momentum = sqrt(sum(v(:, 1))**2 + sum(v(:, 2))**2 + sum(v(:, 3))**2)

    write(2, '(5(es26.16))') time, K, U, momentum, ins_T

    !Equilibrium distribution of the velocity components.
    if ((switch).and.(t >= time_steps/2)) then
      avg_T = avg_T + ins_T
      do i = 1, N
        write(1, '(3(es26.16))') v(i, :)
      end do
    end if

    if (mod(t, time_steps/10) == 0) write(*, '(i0,a)') t*100/time_steps, '%'
  end do

  avg_T = avg_T / (time_steps/2)
  if (avg_T > 0.0d0) write(1, '(a,es8.2)') '# avg_T=', avg_T

  call cpu_time(t2)
  print*, total_time(t1, t2)

  close(1)
  close(2)
end program report_02_01
