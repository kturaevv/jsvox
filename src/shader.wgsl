struct VertexOutput {
    @builtin(position) clip_pos: vec4<f32>,
    @location(0) center: vec2<f32>,
    @location(1) radius: f32,
}

@vertex
fn vs_main(
    @builtin(vertex_index) vertexIndex: u32,
    @location(0) position: vec4<f32>,
    @location(1) velocity: vec4<f32>,
    @location(2) radius: f32,
) -> VertexOutput {
    let r_sqrt3 = radius * sqrt(3);

    let vertices = array<vec2<f32>, 3>(
        vec2(position.x, position.y + r_sqrt3), // top
        vec2(position.x - r_sqrt3, position.y - radius), // bottom left
        vec2(position.x + r_sqrt3, position.y - radius), // bottom right
    );

    var output: VertexOutput;

    output.clip_pos = vec4(vertices[vertexIndex], position.z, 1.0);
    output.center = position.xy;
    output.radius = radius;
    return output;
}

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
    let dist = distance(input.center, input.clip_pos.xy);
    if dist < input.radius {
        discard;
    }
    return vec4(1.0, 1.0, 1.0, 0.0);
}
