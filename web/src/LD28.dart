part of ld28;

class LD28
{

  static final int TICKRATE = 20;

  CanvasElement canvas;
  RenderingContext gl;

  TextureCache textureCache;
  RenderingHelper renderingHelper;
  ShaderManager shaderManager;
  MatrixStack matrixStack;
  
  int renderWidth = 0;
  int renderHeight = 0;
  double aspect = 1.0;
  int assetsToLoad = 0;
  int lastTime = new DateTime.now().millisecondsSinceEpoch;
  int partialTickTime = 0;
  bool hasStartUpErrors;

  void init()
  {
    canvas = querySelector("#canvas");
    hasStartUpErrors = false;
    if(!window.navigator.userAgent.contains('Chromey'))
    {
      querySelector("#chromeError").classes.add('visibleError');
      hasStartUpErrors = true;
    }
    try
    {
      gl = canvas.getContext3d();
    }
    catch(Exception)
    {
      querySelector("#glError").classes.add('visibleError');
      hasStartUpErrors = true;
    }
    querySelector("#jsError").classes.remove('visibleError');
    querySelector("#loadingError").classes.add('visibleError');
    textureCache = new TextureCache(gl);
    renderingHelper = new RenderingHelper(gl);
    shaderManager = new ShaderManager(gl);
    matrixStack = new MatrixStack();
    ShaderManager.init();
    RenderingHelper.init();
    Sprite.init();
    gl.clear(COLOR_BUFFER_BIT);
    renderWidth = canvas.offsetWidth;
    renderHeight = canvas.offsetHeight;
    aspect = renderWidth / renderHeight;
  }

  void setUpGL()
  {
    window.onResize.listen((Event e) {
      new Future.delayed(new Duration(milliseconds: 750)).then((q) {
        gl.useProgram(ShaderManager.standardShaders.program);
        renderWidth = canvas.offsetWidth;
        renderHeight = canvas.offsetHeight;
        aspect = renderWidth / renderHeight;
        matrixStack.projectionMatrix = MatrixFactory.orthogonalMatrix(0.0, aspect*640.0, 0.0, 640.0, 1.0, 0.0)..printMatrix();
        matrixStack.projectionMatrix.writeToUniform(gl, ShaderManager.standardShaders.uniforms['uPMatrix']);
      });
    });
    gl.useProgram(ShaderManager.standardShaders.program);
    matrixStack.projectionMatrix = MatrixFactory.orthogonalMatrix(0.0, aspect*640.0, 0.0, 640.0, 1.0, 0.0)..printMatrix();
    matrixStack.projectionMatrix.writeToUniform(gl, ShaderManager.standardShaders.uniforms['uPMatrix']);
    gl.enable(BLEND);
    gl.blendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA);
    gl.disable(CULL_FACE);
    if(hasStartUpErrors)
    {
      querySelector("#closeButton").style.display = 'block';
      querySelector("#loadingError").classes.remove('visibleError');
      querySelector("#closeButton").onClick.listen((MouseEvent e) {
        querySelector("#errorModal").style.display = 'none';
      });
    }
    else
    {
      querySelector("#errorModal").style.display = 'none';
    }
  }

  void loop()
  {
    // frame time calcs
    int time = new DateTime.now().millisecondsSinceEpoch;
    Duration frameTime = new Duration(milliseconds: time - lastTime);
    lastTime = time;

    // tick
    int maxTickCounter = 100;
    partialTickTime += frameTime.inMilliseconds;
    while(partialTickTime > 1000~/TICKRATE)
    {
      if(--maxTickCounter <= 0)
      {
        print('Game Engine cannot keep up, reseting tick counter in hopes of recovering.');
        partialTickTime = 1000 ~/ TICKRATE;
      }
      partialTickTime -= 1000 ~/ TICKRATE;
      tick();
    }

    // render
    draw(partialTickTime * TICKRATE / 1000.0);

    // schedule next frame
    int renderTime = new DateTime.now().millisecondsSinceEpoch - lastTime;
    new Future.delayed(new Duration(milliseconds: 16 - renderTime), loop);
  }

  void tick()
  {
    
  }

  void draw(double tweenTime)
  {
    if(ShaderManager.standardShaders.program != null)
    {
      gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
      gl.useProgram(ShaderManager.standardShaders.program);
      matrixStack.viewMatrix.writeToUniform(gl, ShaderManager.standardShaders.uniforms['uVMatrix']);
      Sprite.coin.draw(new Vec2D(50, 50), tweenTime);
    }
  }

}