//CODE BASÉ SUR : https://www.processing.org/tutorials/pshader/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying float z;

void main() {

  float boundary = 193;

  // Test pour afficher les lignes de niveau
  if (mod(abs(z),3) <= 0.2 && abs(z) <= boundary) {
    gl_FragColor = texture2D(texture, vertTexCoord.st) *vec4(0.3, 0.3, 0.3, 1.0); 
  } else {
    if (abs(z) > boundary) {
      gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(0.5, 1.5, 0.5, 1.0); 
    } else {
      gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor; 
    }
  }
} 
