part of ld28;

class ShaderProgram
{

  Program program;
  Map<String, int> attributes = new Map<String, int>();
  Map<String, UniformLocation> uniforms = new Map<String, UniformLocation>();

  ShaderProgram(String vsURL, String fsURL, [List<String> attributes, List<String> uniforms])
  {
    gameInstance.shaderManager.loadProgram(vsURL, fsURL, (Program program) {
      this.program = program;
      for(String attribute in attributes)
      {
        this.attributes[attribute] = gameInstance.gl.getAttribLocation(program, attribute);
      }
      for(String uniform in uniforms)
      {
        this.uniforms[uniform] = gameInstance.gl.getUniformLocation(program, uniform);
      }
    });
  }

}

class ShaderManager
{

  static ShaderProgram standardShaders = new ShaderProgram('shader/standard-vertex-shader.txt', 'shader/standard-fragment-shader.txt',
      ['aVertexPosition', 'aVertexTextureCoord'], ['uMMatrix', 'uVMatrix', 'uPMatrix', 'uSampler']);

  RenderingContext context;

  ShaderManager(this.context);
  
  static init()
  {
    // load our static members:
    standardShaders;
  }

  Shader createShader(String src, int type)
  {
    Shader shader = context.createShader(type);
    context.shaderSource(shader, src);
    context.compileShader(shader);
    if(DEBUG && !context.getShaderParameter(shader, COMPILE_STATUS))
    {
      window.alert("Shader Compile Error: " + context.getShaderInfoLog(shader));
    }
    return shader;
  }

  Program createProgram(String vs, String fs)
  {
    Program program = context.createProgram();
    Shader vshader = createShader(vs, VERTEX_SHADER);
    Shader fshader = createShader(fs, FRAGMENT_SHADER);
    context.attachShader(program, vshader);
    context.attachShader(program, fshader);
    context.linkProgram(program);
    if(DEBUG && !context.getProgramParameter(program, LINK_STATUS))
    {
      window.alert("Shader Link Error: " + context.getProgramInfoLog(program));
    }
    --gameInstance.assetsToLoad;
    return program;
  }

  void loadProgram(String vsURL, String fsURL, void callback(Program p))
  {
    gameInstance.assetsToLoad += 1;
    String vshaderSource;
    String fshaderSource;
    void vshaderLoaded(String source)
    {
      vshaderSource = source;
      if(fshaderSource != null)
      {
        callback(createProgram(vshaderSource, fshaderSource));
      }
    }
    void fshaderLoaded(String source)
    {
      fshaderSource = source;
      if(vshaderSource != null)
      {
        callback(createProgram(vshaderSource, fshaderSource));
      }
    }
    HttpRequest.getString(vsURL).then(vshaderLoaded);
    HttpRequest.getString(fsURL).then(fshaderLoaded);
  }

}