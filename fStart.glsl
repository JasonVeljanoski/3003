#version 120

varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;
uniform float texScale;

varying vec3 position;
varying vec3 normal; /* get rid of variying as this is only in vertex shader */

vec3 fL, fE, fH, fN;
vec3 sL, sE, sH, sN;

varying vec3 vNorm;
varying vec3 vNorm2;

varying vec3 pos, Lvec;
varying vec3 pos2, Lvec2;

uniform vec4 LightPosition;
uniform float Shininess;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 AmbientProduct2, DiffuseProduct2, SpecularProduct2;

uniform mat4 ModelView;
uniform vec3 Light1colBrightness, Light2colBrightness;

void main()
{
    /* Part G. Move stuff from vertex shader to fragment shader */

    // Unit direction vectors for Blinn-Phong shading calculation
    // Part I. second light here
    fL = normalize( Lvec ); sL = normalize( Lvec2 );   // Direction to the light source
    fE = normalize( -pos ); sE = normalize( -pos );  // Direction to the eye/camera
    fH = normalize( fL + fE ); sH = normalize( sL + sE );  // Halfway vector
    
    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    // Part I. second light here
    fN = normalize( (ModelView*vec4(vNorm, 0.0)).xyz );  sN = normalize( (ModelView*vec4(vNorm, 0.0)).xyz );

    /* Part H. calculate ambient and diffuse as a function of texture. specular lighting does not */
    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct; vec3 ambient2 = AmbientProduct2; // [Part H.] 
  
    float Kd = max( dot(fL, fN), 0.0 ); float Kd2 = max( dot(sL, sN), 0.0 );
    vec3  diffuse = Kd * DiffuseProduct; vec3  diffuse2 = Kd2 * DiffuseProduct2; // [Part H.]

    float Ks = pow( max(dot(fN, fH), 0.0), Shininess ); float Ks2 = pow( max(dot(sN, sH), 0.0), Shininess );
    vec3 specular = Ks * SpecularProduct; vec3 specular2 = Ks2 * SpecularProduct2;
    
    if (dot(fL, fN) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 
    if (dot(sL, sN) < 0.0 ) {
	    specular2 = vec3(0.0, 0.0, 0.0);
    } 

    // Part F.
    /* calculate an appropriate attenuation based on the distance of light source */
    float lenVec = length(Lvec); float lenVec2 = length(Lvec2);
    float a = 0.5; float a2 = 0.5; // weight (pick what looks good)
    float b = 0.0; float b2 = 0.0; // weight (pick what looks good)
    // calculate attenuation
    float att = 1.0 / (1.0 + a*lenVec + b*lenVec*lenVec); float att2 = 1.0 / (1.0 + a*lenVec2 + b*lenVec2*lenVec2);
    
    vec3 globalAmbient = vec3(0.1, 0.1,0.1);
    vec4 color; 
    color.rgb = globalAmbient + att*(ambient + diffuse + specular);
    color.a = 1.0;

    vec4 color2; 
    color2.rgb = globalAmbient + att2*(ambient2 + diffuse2 + specular2);
    color2.a = 1.0;

    // Part B. textScale changes with middle mouse vertical position to zoom the texture within the object
    gl_FragColor = (color + color2) * texture2D( texture, texCoord * texScale );

}
