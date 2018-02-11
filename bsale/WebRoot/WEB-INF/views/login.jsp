<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="inc.jsp"></jsp:include>
<meta http-equiv="X-UA-Compatible" content="edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户登录</title>
<script>

	var sessionInfo_userId = '${sessionInfo.id}';
	if (sessionInfo_userId) {//如果登录,直接跳转到index页面
		window.location.href='${ctx}/admin/index';
	}
		
	$(function() {
		
		$('#loginform').form({
		    url:'${ctx}/admin/login',
		    onSubmit : function() {
		    	progressLoad();
				var isValid = $(this).form('validate');
				if(!isValid){
					progressClose();
				}
				return isValid;
			},
		    success:function(result){
		    	result = $.parseJSON(result);
		    	progressClose();
		    	if (result.success) {
		    		window.location.href='${ctx}/admin/index';
		    	}else{
		    		$.messager.show({
		    			title:'提示',
		    			msg:'<div class="light-info"><div class="light-tip icon-tip"></div><div>用户名或密码错误</div></div>',
		    			showType:'show'
		    		});
		    	}
		    }
		});
	});
	function submitForm(){
		$('#loginform').submit();
	}
	
	function clearForm(){
		$('#loginform').form('clear');
	}
	
	function enterlogin(){
		if (event.keyCode == 13){
			document.getElementById('login').focus(); 
        	event.returnValue=false;
        	event.cancel = true;
        	$('#loginform').submit();
    	}
	}
	
</script>
</head>
<body onkeydown="enterlogin();"style="background-color: #000;">
<canvas id="canvas">Canvas is not supported in your browser.</canvas>
	<div align="center" style="height:250px;margin-top: -800px;">
	<div   style="width:320px;height:250px; " >
		<div  align="center" ><img style="width:320px;height:200px;" src="${ctx}/static/style/images/index/logo.png" /></div>
		<div style="padding:10px 10px 10px 10px" align="center" >
	    <form id="loginform"  method="post">
	    	<div style="margin-bottom:10px">
    	    	<input class="easyui-textbox" name="loginname" style="width:100%;height:40px;padding:12px" data-options="prompt:'输入用户名',iconCls:'icon_login',iconWidth:38">
	       	</div>
            <div style="margin-bottom:20px">
            	<input class="easyui-textbox" type="password" name="password" style="width:100%;height:40px;padding:12px" data-options="prompt:'请输入密码',iconCls:'',iconWidth:38">
	    	</div>
	    	<div>
	    		<a id="login" onclick="submitForm()" href="javascript:void(0)" class="easyui-linkbutton"  style="padding:5px 0px;width:100%;border-color: #0b7daf;background-color: #0b7daf"><span style="font-size:14px;">登 录</span></a>
			</div>
	    </form>
	    </div>
	</div>
	</div>
	
	<!--[if lte IE 7]>
	<div id="ie6-warning"><p>您正在使用 低版本浏览器，在本页面可能会导致部分功能无法使用。建议您升级到 <a href="http://www.microsoft.com/china/windows/internet-explorer/" target="_blank">Internet Explorer 8</a> 或以下浏览器：
	<a href="http://www.mozillaonline.com/" target="_blank">Firefox</a> / <a href="http://www.google.com/chrome/?hl=zh-CN" target="_blank">Chrome</a> / <a href="http://www.apple.com.cn/safari/" target="_blank">Safari</a> / <a href="http://www.operachina.com/" target="_blank">Opera</a></p></div>
	<![endif]-->
	
	<style>
	/*ie6提示*/
	#ie6-warning{width:100%;position:absolute;top:0;left:0;background:#fae692;padding:5px 0;font-size:12px}
	#ie6-warning p{width:960px;margin:0 auto;}
	</style>
	<script>
	window.requestAnimFrame = ( function() {
		return window.requestAnimationFrame ||
					window.webkitRequestAnimationFrame ||
					window.mozRequestAnimationFrame ||
					function( callback ) {
						window.setTimeout( callback, 1000 / 60 );
					};
	})();

	// now we will setup our basic variables for the demo
	var canvas = document.getElementById( 'canvas' ),
			ctx = canvas.getContext( '2d' ),
			// full screen dimensions
			cw = window.innerWidth,
			ch = window.innerHeight,
			// firework collection
			fireworks = [],
			// particle collection
			particles = [],
			// starting hue
			hue = 120,
			// when launching fireworks with a click, too many get launched at once without a limiter, one launch per 5 loop ticks
			limiterTotal = 5,
			limiterTick = 0,
			// this will time the auto launches of fireworks, one launch per 80 loop ticks
			timerTotal = 80,
			timerTick = 0,
			mousedown = false,
			// mouse x coordinate,
			mx,
			// mouse y coordinate
			my;
			
	// set canvas dimensions
	canvas.width = cw;
	canvas.height = ch;

	// now we are going to setup our function placeholders for the entire demo

	// get a random number within a range
	function random( min, max ) {
		return Math.random() * ( max - min ) + min;
	}

	// calculate the distance between two points
	function calculateDistance( p1x, p1y, p2x, p2y ) {
		var xDistance = p1x - p2x,
				yDistance = p1y - p2y;
		return Math.sqrt( Math.pow( xDistance, 2 ) + Math.pow( yDistance, 2 ) );
	}

	// create firework
	function Firework( sx, sy, tx, ty ) {
		// actual coordinates
		this.x = sx;
		this.y = sy;
		// starting coordinates
		this.sx = sx;
		this.sy = sy;
		// target coordinates
		this.tx = tx;
		this.ty = ty;
		// distance from starting point to target
		this.distanceToTarget = calculateDistance( sx, sy, tx, ty );
		this.distanceTraveled = 0;
		// track the past coordinates of each firework to create a trail effect, increase the coordinate count to create more prominent trails
		this.coordinates = [];
		this.coordinateCount = 3;
		// populate initial coordinate collection with the current coordinates
		while( this.coordinateCount-- ) {
			this.coordinates.push( [ this.x, this.y ] );
		}
		this.angle = Math.atan2( ty - sy, tx - sx );
		this.speed = 2;
		this.acceleration = 1.05;
		this.brightness = random( 50, 70 );
		// circle target indicator radius
		this.targetRadius = 1;
	}

	// update firework
	Firework.prototype.update = function( index ) {
		// remove last item in coordinates array
		this.coordinates.pop();
		// add current coordinates to the start of the array
		this.coordinates.unshift( [ this.x, this.y ] );
		
		// cycle the circle target indicator radius
		if( this.targetRadius < 8 ) {
			this.targetRadius += 0.3;
		} else {
			this.targetRadius = 1;
		}
		
		// speed up the firework
		this.speed *= this.acceleration;
		
		// get the current velocities based on angle and speed
		var vx = Math.cos( this.angle ) * this.speed,
				vy = Math.sin( this.angle ) * this.speed;
		// how far will the firework have traveled with velocities applied?
		this.distanceTraveled = calculateDistance( this.sx, this.sy, this.x + vx, this.y + vy );
		
		// if the distance traveled, including velocities, is greater than the initial distance to the target, then the target has been reached
		if( this.distanceTraveled >= this.distanceToTarget ) {
			createParticles( this.tx, this.ty );
			// remove the firework, use the index passed into the update function to determine which to remove
			fireworks.splice( index, 1 );
		} else {
			// target not reached, keep traveling
			this.x += vx;
			this.y += vy;
		}
	}

	// draw firework
	Firework.prototype.draw = function() {
		ctx.beginPath();
		// move to the last tracked coordinate in the set, then draw a line to the current x and y
		ctx.moveTo( this.coordinates[ this.coordinates.length - 1][ 0 ], this.coordinates[ this.coordinates.length - 1][ 1 ] );
		ctx.lineTo( this.x, this.y );
		ctx.strokeStyle = 'hsl(' + hue + ', 100%, ' + this.brightness + '%)';
		ctx.stroke();
		
		ctx.beginPath();
		// draw the target for this firework with a pulsing circle
		ctx.arc( this.tx, this.ty, this.targetRadius, 0, Math.PI * 2 );
		ctx.stroke();
	}

	// create particle
	function Particle( x, y ) {
		this.x = x;
		this.y = y;
		// track the past coordinates of each particle to create a trail effect, increase the coordinate count to create more prominent trails
		this.coordinates = [];
		this.coordinateCount = 5;
		while( this.coordinateCount-- ) {
			this.coordinates.push( [ this.x, this.y ] );
		}
		// set a random angle in all possible directions, in radians
		this.angle = random( 0, Math.PI * 2 );
		this.speed = random( 1, 10 );
		// friction will slow the particle down
		this.friction = 0.95;
		// gravity will be applied and pull the particle down
		this.gravity = 1;
		// set the hue to a random number +-20 of the overall hue variable
		this.hue = random( hue - 20, hue + 20 );
		this.brightness = random( 50, 80 );
		this.alpha = 1;
		// set how fast the particle fades out
		this.decay = random( 0.015, 0.03 );
	}

	// update particle
	Particle.prototype.update = function( index ) {
		// remove last item in coordinates array
		this.coordinates.pop();
		// add current coordinates to the start of the array
		this.coordinates.unshift( [ this.x, this.y ] );
		// slow down the particle
		this.speed *= this.friction;
		// apply velocity
		this.x += Math.cos( this.angle ) * this.speed;
		this.y += Math.sin( this.angle ) * this.speed + this.gravity;
		// fade out the particle
		this.alpha -= this.decay;
		
		// remove the particle once the alpha is low enough, based on the passed in index
		if( this.alpha <= this.decay ) {
			particles.splice( index, 1 );
		}
	}

	// draw particle
	Particle.prototype.draw = function() {
		ctx. beginPath();
		// move to the last tracked coordinates in the set, then draw a line to the current x and y
		ctx.moveTo( this.coordinates[ this.coordinates.length - 1 ][ 0 ], this.coordinates[ this.coordinates.length - 1 ][ 1 ] );
		ctx.lineTo( this.x, this.y );
		ctx.strokeStyle = 'hsla(' + this.hue + ', 100%, ' + this.brightness + '%, ' + this.alpha + ')';
		ctx.stroke();
	}

	// create particle group/explosion
	function createParticles( x, y ) {
		// increase the particle count for a bigger explosion, beware of the canvas performance hit with the increased particles though
		var particleCount = 30;
		while( particleCount-- ) {
			particles.push( new Particle( x, y ) );
		}
	}

	// main demo loop
	function loop() {
		// this function will run endlessly with requestAnimationFrame
		requestAnimFrame( loop );
		
		// increase the hue to get different colored fireworks over time
		hue += 0.5;
		
		// normally, clearRect() would be used to clear the canvas
		// we want to create a trailing effect though
		// setting the composite operation to destination-out will allow us to clear the canvas at a specific opacity, rather than wiping it entirely
		ctx.globalCompositeOperation = 'destination-out';
		// decrease the alpha property to create more prominent trails
		ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
		ctx.fillRect( 0, 0, cw, ch );
		// change the composite operation back to our main mode
		// lighter creates bright highlight points as the fireworks and particles overlap each other
		ctx.globalCompositeOperation = 'lighter';
		
		// loop over each firework, draw it, update it
		var i = fireworks.length;
		while( i-- ) {
			fireworks[ i ].draw();
			fireworks[ i ].update( i );
		}
		
		// loop over each particle, draw it, update it
		var i = particles.length;
		while( i-- ) {
			particles[ i ].draw();
			particles[ i ].update( i );
		}
		
		// launch fireworks automatically to random coordinates, when the mouse isn't down
		if( timerTick >= timerTotal ) {
			if( !mousedown ) {
				// start the firework at the bottom middle of the screen, then set the random target coordinates, the random y coordinates will be set within the range of the top half of the screen
				fireworks.push( new Firework( cw / 2, ch, random( 0, cw ), random( 0, ch / 2 ) ) );
				timerTick = 0;
			}
		} else {
			timerTick++;
		}
		
		// limit the rate at which fireworks get launched when mouse is down
		if( limiterTick >= limiterTotal ) {
			if( mousedown ) {
				// start the firework at the bottom middle of the screen, then set the current mouse coordinates as the target
				fireworks.push( new Firework( cw / 2, ch, mx, my ) );
				limiterTick = 0;
			}
		} else {
			limiterTick++;
		}
	}

	// mouse event bindings
	// update the mouse coordinates on mousemove
	canvas.addEventListener( 'mousemove', function( e ) {
		mx = e.pageX - canvas.offsetLeft;
		my = e.pageY - canvas.offsetTop;
	});

	// toggle mousedown state and prevent canvas from being selected
	canvas.addEventListener( 'mousedown', function( e ) {
		e.preventDefault();
		mousedown = true;
	});

	canvas.addEventListener( 'mouseup', function( e ) {
		e.preventDefault();
		mousedown = false;
	});

	// once the window loads, we are ready for some fireworks!
	window.onload = loop;
	</script>
	</body>
</html>