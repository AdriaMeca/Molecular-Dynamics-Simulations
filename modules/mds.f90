!Author: Adrià Meca.
module mds
  implicit none

  private

  public kin_energy, pressure, pbc, total_time, andersen, euler, force, &
    init_sc, normal_distribution, vel_verlet

contains
  !Function that calculates the kinetic energy of the system.
  double precision function kin_energy(v)
    implicit none

    double precision, dimension(:, :), intent(in) :: v

    integer :: i

    kin_energy = 0.0d0
    do i = 1, size(v, dim=1)
      kin_energy = kin_energy + 0.5d0*sum(v(i, :)**2)
    end do
  end function kin_energy


  !Function that calculates de pressure of the system.
  double precision function pressure(rho, T, L, r, F)
    implicit none

    double precision, dimension(:, :), intent(in) :: r, F
    double precision, intent(in) :: rho, T, L

    double precision, dimension(3) :: rij, Fij
    integer :: i, j, N

    N = size(r, dim=1)

    pressure = 0.0d0
    do i = 1, N
      do j = i+1, N
        rij = r(i, :) - r(j, :)
        Fij = F(i, :) - F(j, :)
        pressure = pressure + sum(abs(rij*Fij))
      end do
    end do
    pressure = rho*T + pressure/3/(L**3)
  end function pressure


  !Periodic boundary conditions.
  function pbc(x, L) result(alt_x)
    implicit none

    double precision, dimension(:), intent(in) :: x
    double precision, intent(in) :: L

    double precision, dimension(size(x)) :: alt_x
    integer :: i

    alt_x = x
    do i = 1, size(x)
      if (x(i) > L/2) then
        alt_x(i) = x(i) - L
      else if (x(i) < -L/2) then
        alt_x(i) = x(i) + L
      end if
    end do
  end function pbc


  !Function that calculates the time lapse between t1 and t2, writing it in the
  !most suitable units of time.
  function total_time(t1, t2) result(message)
    implicit none

    real, intent(in) :: t1, t2

    integer, parameter :: case1=60, case2=case1*60, case3=case2*24
    character(len=19) :: message
    character(len=11) :: header='# CPU_TIME='
    real :: time

    time = t2 - t1
    select case (floor(time))
      case (:case1-1)
        write(message, 100) header, time, 's.'
      case (case1:case2-1)
        write(message, 100) header, time/case1, 'm.'
      case (case2:case3-1)
        write(message, 100) header, time/case2, 'h.'
      case (case3:)
        write(message, 100) header, time/case3, 'd.'
    end select
    100 format (a11,f5.2,a3)
  end function total_time


  !Andersen thermostat.
  subroutine andersen(v, dt, nu, sigma)
    implicit none

    double precision, dimension(:, :), intent(inout) :: v
    double precision, intent(in) :: dt, nu, sigma

    double precision, dimension(2) :: r1, r2
    double precision :: random
    integer :: i

    do i = 1, size(v, dim=1)
      call random_number(r1)
      call random_number(r2)
      call normal_distribution(r1, sigma)
      call normal_distribution(r2, sigma)

      call random_number(random)
      if (random < nu*dt) then
        v(i, 1) = r1(1); v(i, 2) = r1(2); v(i, 3) = r2(1)
      end if
    end do
  end subroutine andersen


  !Euler integrator.
  subroutine euler(r, v, U, dt, rc, L, bc)
    implicit none

    double precision, dimension(:, :), intent(inout) :: r, v
    double precision, intent(out) :: U
    double precision, intent(in) :: dt, L, rc
    logical, intent(in) :: bc

    double precision, dimension(size(r, dim=1), size(r, dim=2)) :: F

    call force(r, rc, L, bc, F, U)

    r = r + v*dt + F*dt**2/2
    v = v + F*dt
  end subroutine euler


  !Subroutine that calculates the forces and potential energy of the system.
  subroutine force(r, rc, L, bc, F, U)
    implicit none

    double precision, dimension(:, :), intent(out) :: F
    double precision, dimension(:, :), intent(in) :: r
    double precision, intent(out) :: U
    double precision, intent(in) :: L, rc
    logical, intent(in) :: bc

    double precision, dimension(3) :: dr, r1, r2
    double precision :: d
    integer :: i, j, N

    N = size(r, dim=1)

    F = 0.0d0
    U = 0.0d0
    do i = 1, N
      do j = i+1, N
        r1 = r(i, :)
        r2 = r(j, :)

        if (bc) then
          dr = pbc(r1-r2, L)
        else
          dr = r1 - r2
        end if

        d = sqrt(sum(dr**2))

        if (d > rc) cycle

        F(i, :) = F(i, :) + (48/d**14-24/d**8)*dr
        F(j, :) = F(j, :) - (48/d**14-24/d**8)*dr

        U = U + 4.0d0*(1.0d0/d**12-1/d**6) - 4.0d0*(1.0d0/rc**12-1/rc**6)
      end do
    end do
  end subroutine force


  !Subroutine that initializes the positions of the particles in a sc lattice.
  subroutine init_sc(r, L, M)
    implicit none

    double precision, dimension(:, :), intent(inout) :: r
    double precision, intent(in) :: L
    integer, intent(in) :: M

    integer :: i, idx, j, k

    idx = 0
    do k = 0, M-1
      do j = 0, M-1
        do i = 0, M-1
          idx = idx + 1
          r(idx, :) = (/ i, j, k /)
        end do
      end do
    end do
    r = (L/M) * r
  end subroutine init_sc


  !Subroutine that generates normally distributed random numbers.
  subroutine normal_distribution(random, sigma)
    implicit none

    double precision, dimension(:), intent(inout) :: random
    double precision, intent(in) :: sigma

    double precision :: pi, x1, x2

    pi = 4.0d0 * atan(1.0d0)

    x1 = random(1)
    x2 = random(2)

    random(1) = sigma * sqrt(-2.0d0*log(1.0d0-x1))*cos(2.0d0*pi*x2)
    random(2) = sigma * sqrt(-2.0d0*log(1.0d0-x1))*sin(2.0d0*pi*x2)
  end subroutine normal_distribution


  !Velocity Verlet integrator.
  subroutine vel_verlet(r, v, F, U, dt, rc, L, bc)
    implicit none

    double precision, dimension(:, :), intent(inout) :: r, v, F
    double precision, intent(out) :: U
    double precision, intent(in) :: dt, L, rc
    logical, intent(in) :: bc

    r = r + v*dt + 0.5d0*F*dt**2
    v = v + 0.5d0*F*dt

    call force(r, rc, L, bc, F, U)

    v = v + 0.5d0*F*dt
  end subroutine vel_verlet
end module mds
