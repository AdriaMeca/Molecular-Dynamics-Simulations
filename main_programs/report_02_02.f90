!Author: Adrià Meca.
!Second part of the project: Properties of a Lennard-Jones Liquid.
program report_02_02
  use mds

  implicit none

  !Parameters.
  double precision, parameter :: dt=1.0d-4, nu=1.0d0
  integer, parameter :: N=125
  logical, parameter :: bc=.true.

  !Variables.
  double precision, dimension(N, 3) :: F, r, v
  double precision :: ins_T, K, L, P, rc, rho, sigma, temperature, time, U

  integer, dimension(:), allocatable :: seed
  integer :: i, M, s, t, time_steps

  real :: t1, t2

  open(unit=1, file="../data/thermodynamics_02_02.dat")

  !We fix the seed for reproducibility.
  call random_seed(size=s)
  allocate(seed(s))
  seed = 0
  call random_seed(put=seed)
  deallocate(seed)

  call cpu_time(t1)

  rho = 0.2d0

  write(*, '(a,es7.1)') '# rho=', rho
  write(1, '(a,es7.1)') '# rho=', rho
  write(1, '(a,a25,4(a26))') '#', 't', 'K', 'U', 'T', 'P'

  !Size of the system given the density.
  L = (N/rho)**(1/3.0d0)
  M = nint(N**(1/3.0d0))

  !Cutoff.
  rc = L / 4

  !Initial positions of the particles.
  r = 0.0d0
  v = 0.0d0
  call init_sc(r, L, M)

  !We apply pbc to center the lattice at (0, 0, 0).
  if (bc) then
    do i = 1, N
      r(i, :) = pbc(r(i, :), L)
    end do
  end if

  !Initial force and potential energy.
  call force(r, rc, L, bc, F, U)

  temperature = 100.0d0
  sigma = sqrt(temperature)

  !We melt the lattice.
  time_steps = 10000
  do t = 0, time_steps
    if (t > 0) then
      !We advance the time step.
      call vel_verlet(r, v, F, U, dt, rc, L, bc)

      !We apply pbc.
      if (bc) then
        do i = 1, N
          r(i, :) = pbc(r(i, :), L)
        end do
      end if
    end if
  end do

  temperature = 2.0d0
  sigma = sqrt(temperature)

  !Molecular Dynamics Simulation.
  time = 0.0d0
  time_steps = 1000000
  do t = 0, time_steps
    if (t > 0) then
      !We advance the time step.
      time = time + dt
      call vel_verlet(r, v, F, U, dt, rc, L, bc)
      call andersen(v, dt, nu, sigma)

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

    !Pressure.
    P = pressure(rho, ins_T, L, r, F)

    write(1, '(5(es26.16))') time, K, U, ins_T, P

    if (mod(t, time_steps/10) == 0) write(*, '(i0,a)') t*100/time_steps, '%'
  end do

  call cpu_time(t2)
  write(1, '(a)') '#' // achar(10) // total_time(t1, t2)

  close(1)
end program report_02_02
