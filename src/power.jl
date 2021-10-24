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
    except_right_tail = cdf(d1, critical_value)
    right_tail = 1 - except_right_tail
    return tail == one_tail ? right_tail : 2 * right_tail
end

distribution_parameters(T::TTest; n) = n - 1
distribution_parameters(T::IndependentSamplesTTest; n) = n - 2 # n1 + n2 - 2
distribution_parameters(T::ChiSqTest; n) = T.df
distribution_parameters(T::ANOVATest; n) = (T.n_groups - 1, (n - 1) * T.n_groups)

noncentrality_parameter(T::TTest; es, n) = sqrt(n) * es
noncentrality_parameter(T::IndependentSamplesTTest; es, n) = sqrt(n / 2) * es
noncentrality_parameter(T::ChiSqTest; es, n) = n * es^2
noncentrality_parameter(T::ANOVATest; es, n) = n * es^2 * T.n_groups

noncentral_distribution(T::TTest) = NoncentralT
noncentral_distribution(T::ChiSqTest) = NoncentralChisq
noncentral_distribution(T::FTest) = NoncentralF

tail(T::TTest) = T.tail
tail(T::StatisticalTest) = one_tail

function get_power(T::StatisticalTest; es::Real, alpha::Real, n)
    v = distribution_parameters(T; n)
    λ = noncentrality_parameter(T; es, n)
    d = noncentral_distribution(T)
    d1 = d(v..., 0)
    d2 = d(v..., λ)
    return _power(d1, d2, alpha, tail(T))
end

function get_alpha(T::StatisticalTest; es::Real, power::Real, n)
    v = distribution_parameters(T; n)
    λ = noncentrality_parameter(T; es, n)
    d = noncentral_distribution(T)
    d1 = d(v, 0)
    d2 = d(v, λ)
    return _alpha(d1, d2, power, tail(T))
end

function get_es(T::StatisticalTest; alpha::Real, power::Real, n)
    f(es) = get_alpha(T; es, power, n) - alpha
    initial_value = 0.5
    return find_zero(f, initial_value)
end

function get_n(T::StatisticalTest; alpha::Real, power::Real, es::Real)
    f(n) = get_alpha(T; es, power, n) - alpha
    initial_value = 50
    return find_zero(f, initial_value)
end
