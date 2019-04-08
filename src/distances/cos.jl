export dot_similarity, normalize!, cosine_similarity, cosine_distance, angle_distance

"""
Computes the dot product between vectors (it may disapear in a near future in favor of LinearAlgebra.dot)
"""
function dot_similarity(a::AbstractVector{T}, b::AbstractVector{T})::Float64 where {T <: Real}
    s = 0.0
    @fastmath @inbounds @simd for i in eachindex(a)
        s += a[i] * b[i]
    end

    s
end

"""
normalize!

Divides the vector by its norm (in-place operation)
"""
function normalize!(a::AbstractVector{T}) where {T <: Real}
    xnorm = sqrt(dot_similarity(a, a))
    (xnorm <= eps(T)) && error("A valid vector for cosine's normalize! cannot have a zero norm $xnorm -- vec: $a")
    invnorm = 1.0 / xnorm
    @fastmath @inbounds @simd for i in eachindex(a)
        a[i] = a[i] * invnorm
    end

    a
end

"""
normalize!

Divides all column vectors of the matrix by its norm (in-place operation)
"""
function normalize!(a::AbstractMatrix{T}) where {T <: Real}
    for i in size(a, 2)
        normalize!(@view a[:, i])
    end

    a
end

"""
angle_distance

Computes the angle between two vectors, it expects normalized vectors (see normalize! method)
"""
function angle_distance(a::AbstractVector{T}, b::AbstractVector{T})::Float64 where {T <: Real}
    m = max(-1.0, dot_similarity(a, b))
    acos(min(1.0, m))
end

"""
cosine_distance

Computes the cosine distance between two vectors, it expects normalized vectors (see normalize! method).
Please use angle_distance if you are expecting a metric function (instead cosine_distance is a faster
alternative whenever the triangle inequality is not needed)
"""
function cosine_distance(a::AbstractVector{T}, b::AbstractVector{T})::Float64 where {T <: Real}
    1 - dot_similarity(a, b)
end
