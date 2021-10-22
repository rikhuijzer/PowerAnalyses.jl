"""
    _calculate_power(a::UnivariateDistribution, b::UnivariateDistribution, alpha::Real, n::Int)

Return the power.
"""
function _calculate_power(a::UnivariateDistribution, b::UnivariateDistribution, alpha::Real, n::Int; shift_b=0.0)
    return 1
end

"""
    _calculate_alpha(d1::UnivariateDistribution, d2::UnivariateDistribution, power::Real)

Return the alpha.
Specifically, return alpha for which `quantile(d1, alpha) == quantile(d2, beta)`.
"""
function _calculate_alpha(d1::UnivariateDistribution, d2::UnivariateDistribution, power::Real, tail::Tail)
    beta = 1 - power
    critical_value = quantile(d2, beta)
    except_right_tail = cdf(d1, critical_value)
    right_tail = 1 - except_right_tail
    return tail == one_tail ? right_tail : 2 * right_tail
end

function calculate(T::OneSampleTTest; es::Real, power::Real, n::Int)
    v = n - 1
    λ = sqrt(n) * es
    d1 = TDist(v)
    d2 = NoncentralT(v, λ)
    return _calculate_alpha(d1, d2, power, T.tail)
end
