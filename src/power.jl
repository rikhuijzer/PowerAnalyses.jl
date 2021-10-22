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

Return `alpha` for which `quantile(d1, alpha) == quantile(d2, beta)`.
"""
function _alpha(d1::UnivariateDistribution, d2::UnivariateDistribution, power::Real, tail::Tail)
    beta = 1 - power
    critical_value = quantile(d2, beta)
    except_right_tail = cdf(d1, critical_value)
    right_tail = 1 - except_right_tail
    return tail == one_tail ? right_tail : 2 * right_tail
end

function get_power(T::OneSampleTTest; es::Real, alpha::Real, n)
    v = n - 1
    λ = sqrt(n) * es
    d1 = TDist(v)
    d2 = NoncentralT(v, λ)
    return _power(d1, d2, alpha, T.tail)
end

function get_alpha(T::OneSampleTTest; es::Real, power::Real, n)
    v = n - 1
    λ = sqrt(n) * es
    d1 = TDist(v)
    d2 = NoncentralT(v, λ)
    return _alpha(d1, d2, power, T.tail)
end

function get_es(T::OneSampleTTest; alpha::Real, power::Real, n)
    f(es) = get_alpha(T; es, power, n) - alpha
    es_range = (-10, 10)
    return find_zero(f, es_range)
end

function get_n(T::OneSampleTTest; alpha::Real, power::Real, es::Real)
    f(n) = get_alpha(T; es, power, n) - alpha
    n_range = 2:10_000
    return find_zero(f, n_range)
end
