"""
    _power(d0::UnivariateDistribution, d1::UnivariateDistribution, alpha::Real, tail::Tail)

Return `power` for which `quantile(d0, alpha) == quantile(d1, beta)` and `beta = 1 - power`.
"""
function _power(d0::UnivariateDistribution, d1::UnivariateDistribution, alpha::Real, tail::Tail)
    right_tail = tail == one_tail ? alpha : alpha / 2
    upper_critical_value = cquantile(d0, right_tail)
    if tail == one_tail
        return ccdf(d1, upper_critical_value)
    else
        lower_critical_value = quantile(d0, right_tail)
        return cdf(d1, lower_critical_value) + ccdf(d1, upper_critical_value)
    end
end

"""
    _alpha(d0::UnivariateDistribution, d1::UnivariateDistribution, power::Real, tail::Tail)

Return `alpha` for which `quantile(d0, alpha) == quantile(d1, beta)` and `beta = 1 - power`.
"""
function _alpha(d0::UnivariateDistribution, d1::UnivariateDistribution, power::Real, tail::Tail)
    return find_zero((0, 1)) do alpha
        return _power(d0, d1, alpha, tail) - power
    end
end

_distribution_parameters(T::IndependentSamplesTTest, n) = 2 * n - 2 # n1 + n2 - 2
_distribution_parameters(T::PointBiserialTTest, n) = n - 2
_distribution_parameters(T::TTest, n) = n - 1
function _distribution_parameters(T::DeviationFromZeroMultipleRegression, n)
    return (T.n_predictors, n - T.n_predictors - 1)
end
function _distribution_parameters(T::IncreaseMultipleRegression, n)
    return (T.n_tested_predictors, n - T.n_predictors - 1)
end
_distribution_parameters(T::OneWayANOVA, n) = (T.n_groups - 1, n - T.n_groups)
function _distribution_parameters(T::ConstantVectorHotellingTsqTest, n)
    return (T.n_response_variables, n - T.n_response_variables)
end
function _distribution_parameters(T::TwoVectorsHotellingTsqTest, n::AbstractVector)
    return (T.n_response_variables, sum(n) - T.n_response_variables - 1)
end
_distribution_parameters(T::MultifactorFixedEffectsANOVA, n) = (T.df, n - T.n_groups)
_distribution_parameters(T::ConstantVarianceChisqTest, n) = n - 1
_distribution_parameters(T::ChisqTest, n) = T.df

_noncentrality_parameter(T::IndependentSamplesTTest, es, n) = sqrt(n / 2) * es
_noncentrality_parameter(T::PointBiserialTTest, es, n) = sqrt(es^2 / (1 - es^2)) * sqrt(n)
_noncentrality_parameter(T::TTest, es, n) = sqrt(n) * es
_noncentrality_parameter(T::MultifactorFixedEffectsANOVA, es, n) = es^2 * n
function _noncentrality_parameter(T::TwoVectorsHotellingTsqTest, es, n::AbstractVector)
    return es^2 * ((n[1] * n[2]) / (n[1] + n[2]))
end
_noncentrality_parameter(T::FTest, es, n::AbstractVector) = sum(n) * es^2
_noncentrality_parameter(T::FTest, es, n) = n * es^2
_noncentrality_parameter(T::ChisqTest, es, n) = n * es^2

_distribution(T::TTest) = NoncentralT
_distribution(T::ChisqTest) = NoncentralChisq
_distribution(T::FTest) = NoncentralF

_tail(T::TTest) = T.tail
_tail(T::StatisticalTest) = one_tail

"""
    _null_distribution(T::StatisticalTest, v)

Return the distribution for the null hypothesis of test `T` with distribution parameters `v`.
"""
function _null_distribution(T::StatisticalTest, v)
    D = _distribution(T)
    d0 = D(v..., 0)
    return d0
end

"""
    _alternative_distribution(T::StatisticalTest, v; es, n)

Return the distribution for the null hypothesis of test `T` with distribution parameters `v`.
"""
function _alternative_distribution(T::StatisticalTest, v, es, n)
    D = _distribution(T)
    λ = _noncentrality_parameter(T, es, n)
    d1 = D(v..., λ)
    return d1
end

function _alternative_distribution(T::ConstantVarianceChisqTest, v, es, n)
    D = _distribution(T)
    d1 = D(v..., 0)
    d2 = v + es * d1
    return d2
end

"""
    get_power(T::StatisticalTest; es::Real, alpha::Real, n)

Return the power for some test `T` with effect size `es`, required significance level `alpha` and sample size `n`.
"""
function get_power(T::StatisticalTest; es::Real, alpha::Real, n)
    v = _distribution_parameters(T, n)
    d0 = _null_distribution(T, v)
    d1 = _alternative_distribution(T, v, es, n)
    return _power(d0, d1, alpha, _tail(T))
end

"""
    get_alpha(T::StatisticalTest; es::Real, power::Real, n)

Return the significance level for some test `T` with effect size `es`, power `power` and sample size `n`.
"""
function get_alpha(T::StatisticalTest; es::Real, power::Real, n)
    v = _distribution_parameters(T, n)
    d0 = _null_distribution(T, v)
    d1 = _alternative_distribution(T, v, es, n)
    return _alpha(d0, d1, power, _tail(T))
end

"""
    get_es(T::StatisticalTest; alpha::Real, power::Real, n)

Return the minimum effect size for some test `T` with significance level `alpha`, power `power` and sample size `n`.
"""
function get_es(T::StatisticalTest; alpha::Real, power::Real, n)
    initial_value = (0, 1000)
    return find_zero(initial_value) do es
        get_power(T; es, alpha, n) - power
    end
end

"""
    get_n(T::StatisticalTest; alpha::Real, power::Real, es::Real)

Return minimum sample size `n` for some test `T` with significance level `alpha`, power `power` and effect size `es`.
"""
function get_n(T::StatisticalTest; alpha::Real, power::Real, es::Real)
    f(n) = get_alpha(T; es, power, n) - alpha
    step_size = 20
    # There is probably a better way to do this, but it works.
    # This avoids the root finding getting stuck at the wrong side of a curve.
    for lower in 0:step_size:10_000
        overlap = 10
        upper = lower + step_size + overlap
        try
            initial_value = (lower, upper)
            return find_zero(f, initial_value)
        catch
            continue
        end
    end
    return -111.0
end
