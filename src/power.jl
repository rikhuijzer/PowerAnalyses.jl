"""
    _power(d1::UnivariateDistribution, d2::UnivariateDistribution, alpha::Real, tail::Tail)

Return `power` for which `quantile(d1, alpha) == quantile(d2, beta)` and `beta = 1 - power`.
"""
function _power(d1::UnivariateDistribution, d2::UnivariateDistribution, alpha::Real, tail::Tail)
    right_tail = tail == one_tail ? alpha : alpha / 2
    except_right_tail = 1 - right_tail
    critical_value = quantile(d1, except_right_tail)
    beta = cdf(d2, critical_value)
    return 1 - beta
end

"""
    _alpha(d1::UnivariateDistribution, d2::UnivariateDistribution, power::Real, tail::Tail)

Return `alpha` for which `quantile(d1, alpha) == quantile(d2, beta)` and `beta = 1 - power`.
"""
function _alpha(d1::UnivariateDistribution, d2::UnivariateDistribution, power::Real, tail::Tail)
    beta = 1 - power
    critical_value = quantile(d2, beta)
    @show critical_value
    except_right_tail = cdf(d1, critical_value)
    right_tail = 1 - except_right_tail
    return tail == one_tail ? right_tail : 2 * right_tail
end

_distribution_parameters(T::TTest; n) = n - 1
_distribution_parameters(T::IndependentSamplesTTest; n) = n - 2 # n1 + n2 - 2
_distribution_parameters(T::ConstantVarianceChisqTest; n) = n - 1
_distribution_parameters(T::ChisqTest; n) = T.df
_distribution_parameters(T::ANOVATest; n) = (T.n_groups - 1, (n - 1) * T.n_groups)

_noncentrality_parameter(T::TTest; es, n) = sqrt(n) * es
_noncentrality_parameter(T::IndependentSamplesTTest; es, n) = sqrt(n / 2) * es
_noncentrality_parameter(T::ChisqTest; es, n) = n * es^2
_noncentrality_parameter(T::ANOVATest; es, n) = n * es^2 * T.n_groups

_distribution(T::TTest) = NoncentralT
_distribution(T::ChisqTest) = NoncentralChisq
_distribution(T::FTest) = NoncentralF

_tail(T::TTest) = T.tail
_tail(T::StatisticalTest) = one_tail

function _distributions(T::ConstantVarianceChisqTest; v, es, n)
    scale = es
    D = _distribution(T)
    d1 = D(v..., 0)
    d2 = LocationScale(v, es, d1)
    return d1, d2
end

function _distributions(T::StatisticalTest; v, es, n)
    D = _distribution(T)
    d1 = D(v..., 0)
    λ = _noncentrality_parameter(T; es, n)
    d2 = D(v..., λ)
    return d1, d2
end

"""
    get_power(T::StatisticalTest; es::Real, alpha::Real, n)

"""
function get_power(T::StatisticalTest; es::Real, alpha::Real, n)
    v = _distribution_parameters(T; n)
    d1, d2 = _distributions(T; v, es, n)
    return _power(d1, d2, alpha, _tail(T))
end

"""
    get_alpha(T::StatisticalTest; es::Real, power::Real, n)

"""
function get_alpha(T::StatisticalTest; es::Real, power::Real, n)
    v = _distribution_parameters(T; n)
    d1, d2 = _distributions(T; v, es, n)
    return _alpha(d1, d2, power, _tail(T))
end

"""
    get_es(T::StatisticalTest; alpha::Real, power::Real, n)

"""
function get_es(T::StatisticalTest; alpha::Real, power::Real, n)
    f(es) = get_alpha(T; es, power, n) - alpha
    initial_value = 0.5
    return find_zero(f, initial_value)
end

"""
    get_n(T::StatisticalTest; alpha::Real, power::Real, es::Real)

"""
function get_n(T::StatisticalTest; alpha::Real, power::Real, es::Real)
    f(n) = get_alpha(T; es, power, n) - alpha
    initial_value = 50
    return find_zero(f, initial_value)
end
