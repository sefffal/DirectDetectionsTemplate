# This is a Julia file.
# From VS Code / Code Spaces, type "shift enter" to start Julia and run a cell.

## Imports

using DirectDetections, Distributions

## DATA
# Enter your astrometry data here.
# The units should be in milliarcseconds.

# You may also enter PA and separation in degrees and milliarcseconds.
# See documentation for details.

astrom = Astrometry(
    (epoch=mjd("2016-12-15"), ra=133., dec=-174., σ_ra=07.0, σ_dec=07.),
    (epoch=mjd("2017-03-12"), ra=126., dec=-176., σ_ra=04.0, σ_dec=04.),
    (epoch=mjd("2017-03-13"), ra=127., dec=-172., σ_ra=04.0, σ_dec=04.),
    (epoch=mjd("2018-02-08"), ra=083., dec=-133., σ_ra=10.0, σ_dec=10.),
    (epoch=mjd("2018-11-28"), ra=058., dec=-122., σ_ra=10.0, σ_dec=20.),
    (epoch=mjd("2018-12-15"), ra=056., dec=-104., σ_ra=08.0, σ_dec=08.),
)

# Enter GAIA DR3 id of the source here:
gaia_id = 756291174721509376

system_name = :HD91312 

## Model definition
# Consider adjusting priors to fit your problem.

b = Planet{VisualOrbit}(
    Variables(
        a = Uniform(0, 50),
        e = Uniform(0.0, 0.5),
        i = Sine(),
        ω = UniformCircular(),
        Ω = UniformCircular(),
        τ = UniformCircular(1.0),
    ),
    astrom,
    name = :b
)

system = System(
    Variables(
        # Adjust mass prior here:
        M = Normal(1.5, 1),
        plx = gaia_plx(;gaia_id),
                
        # Priors on the centre of mass proper motion
        # pmra = Normal(0, 500),
        # pmdec = Normal(0,  500),
    ),  
    # ProperMotionAnomHGCA(;gaia_id),
    B,
    name=system_name
)