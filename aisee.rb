#!/Users/ian/.rvm/rubies/ruby-2.2.0/bin/ruby

require 'RMagick'
include Magick


class ImageObject
  def initialize(whatColour,fieldWidth,fieldHeight)
    @fieldWidth = fieldWidth
    @fieldHeight = fieldHeight
    @pixels = Array.new(getIndexXY(fieldWidth,fieldHeight),false)
    @whatColour = whatColour
  end

  def addPixel(x,y)
    @pixels[getIndexXY(x,y)] = true
  end

  def whatColour
    return @whatColour
  end

  def listob
      puts("whatColour = (#{@whatColour.red},#{@whatColour.green},#{@whatColour.blue})")
      puts("points.length = #{@pixels.count(true)}")
  end

  def isSet(x,y)
    return(@pixels[getIndexXY(x,y)])
  end

  def getXY(pixie_index)
    retX = pixie_index % @fieldWidth
    retY = ((pixie_index - retX) / @fieldWidth) # + 1

    return retX, retY
  end

  def getIndexXY(x, y)
    retIdx = y * @fieldWidth
    retIdx += x

    return retIdx   
  end

  def printAsStrings
    retStrings = Array.new
    currY = 0
    currStr = ""

    @pixels.each_index do |pxl|
      x,y = getXY(pxl)
     if (x % 4 == 0) && (y % 4 == 0)
      if y>currY
        retStrings.push(currStr)
        currStr = ""
        currY = y
      end

      if isSet(x,y) || isSet(x+1,y) || isSet(x+2,y) || isSet(x+3,y)
        currStr = currStr + "X"
      else
        currStr = currStr + " "
      end
     end
    end

    retStrings.push(currStr)

    return retStrings
  end
end

class InputSource
  def initialize()
    if ARGV.length > 0
      img2 = Magick::Image.read(ARGV[0])[0]
    else
      system "/usr/local/bin/imagesnap image.png"
      img1 = Magick::Image.read('image.png')[0]
      img2 = img1.resize_to_fit(320,240)
    end
# Convert to black & white
# First find the lowest maximum of red, green & blue
# Then set pixels to be black if less than half the found value, white if higher

    @img3 =  img2.quantize(256, Magick::GRAYColorspace)
    @img = @img3.despeckle

    maxR=0
    maxG=0
    maxB=0
    @iPixels = @img.get_pixels(0,0,@img.columns,@img.rows)

    @iPixels.each do |pixie|
      if pixie.red > maxR
        maxR=pixie.red
      end
      if pixie.green > maxG
        maxG=pixie.green
      end
      if pixie.blue > maxB
        maxB=pixie.blue
      end
    end

    midRGB=maxR
    if maxG<midRGB
      midRGB=maxG
    end
    if maxB<midRGB
      midRGB=maxB
    end
    midRGB=midRGB/2

    @iPixels.each do |pixie|
      if (pixie.red < midRGB) and (pixie.green < midRGB) and (pixie.blue < midRGB)
        pixie.red = 0
        pixie.green = 0
        pixie.blue = 0
      else
        pixie.red = 65535
        pixie.green = 65535
        pixie.blue = 65535
      end
    end

    @iPixels.each_index do |pixie|
      x,y = getXY(pixie)
      if y>0 and y<@img.rows-1 and x>0 and x<@img.columns-1
        if @iPixels[pixie].red != @iPixels[getIndexXY(x-1,y-1)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x,y-1)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x+1,y-1)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x-1,y)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x+1,y)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x-1,y+1)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x,y+1)].red and \
           @iPixels[pixie].red != @iPixels[getIndexXY(x+1,y+1)].red
          @iPixels[pixie].red = @iPixels[getIndexXY(x-1,y)].red
          @iPixels[pixie].green = @iPixels[getIndexXY(x-1,y)].green
          @iPixels[pixie].blue = @iPixels[getIndexXY(x-1,y)].blue
        end
      end
    end

    @objs = Array.new
  end

  def listobjects()
    puts("Number of objects: #{@objs.length}")
    @objs.each do |ob|
      ob.listob
    end
    printOut
  end

  def printOut
    outChars=['A','a','B','b','C','c','D','d','E','e','F','f','G','g','H','h','I','i','J','j','K','k','L','l','M','m','N','n','O','o','P','p','Q','q','R','r','S','s','T','t','U','u','V','v','W','w','X','x','Y','y','Z','z','1','2','3','4','5','6','7','8','9','0','!','@','£','$','%','^','&','*','(',')','-','_','=','+','[','{',']','}',';',':','|',',','<','.','>','/','?','~','`','±','§','#','™','‹','›','ﬁ','ﬂ','‡','°','Æ','Ú','»','¿','˘','¯','Ÿ']
    outCount=0

    theOut=@objs[0].printAsStrings     
    theOut.each do |tO|
      tO.tr!('X',outChars[outCount])
    end
    outCount += 1

    @objs.each_index do |blobs|
      if blobs > 0
        tmpOut=@objs[blobs].printAsStrings     
        tmpOut.each_index do |tO|
          t0=tmpOut[tO]
          t9=theOut[tO]

          t0.tr!('X',outChars[outCount])
          tZ=''
          cLen=0
          begin
            if t0[cLen] == ' '
              tZ = tZ + t9[cLen]
            else
              tZ = tZ + t0[cLen]
            end
            cLen += 1
          end while cLen < t0.length
          theOut[tO]=tZ
        end
        outCount += 1
        if outCount >= outChars.length
          outCount=0
        end
      end
    end

    puts(theOut)
  end

  def printsize()
    puts(@img.columns)
    puts(@img.rows)
  end

  def findobjects()
    @usedPixel = Array.new
    @objs = Array.new
    @iPixels.each do |pixie|
      @usedPixel.push(false)
    end

#    create blank object list
    oList = Array.new
#    loop
    @iPixels.each_index do |pixie|
#    if pixel not used
      
      if @usedPixel[pixie] == false
#    get x,y from index
        x,y = getXY(pixie)
#    check if pixel is white or not
#        if (@iPixels[pixie].red == 65535)
#          useWhite=true
#        else
#          useWhite=false
#        end
#    create new object with first pixel set
        @currentObj = ImageObject.new(@iPixels[pixie],@img.columns,@img.rows)
#    create new point list
        plist = Array.new
#    add x,y to new point list
        aPoint=Array.new()
        aPoint.push(x)
        aPoint.push(y)
        plist.push(aPoint)
        begin
          nplist = Array.new
          plist.each do |chkpoint|
            padj = getIndexXY(chkpoint[0],chkpoint[1])
            @currentObj.addPixel(chkpoint[0],chkpoint[1])
            @usedPixel[padj]=true
            (-1 .. 1).each do |i|
              (-1 .. 1).each do |j|
                if (i !=0 ) || (j != 0)
                   nPoint=Array.new()
                   nPoint.push(chkpoint[0]+i)
                   nPoint.push(chkpoint[1]+j)
                   if (nPoint[0]>=0) && (nPoint[1]>=0) && (nPoint[0]<=@img.columns) && (nPoint[1]<=@img.rows)
                     padj = getIndexXY(nPoint[0],nPoint[1])
                     if @usedPixel[padj] == false
#                       if (@iPixels[padj].red == 65535)
#                         newWhite=true
#                       else
#                         newWhite=false
#                       end
      
                       if @iPixels[padj].red == @currentObj.whatColour.red
                         if nplist.index(nPoint) == nil
                           @usedPixel[padj]=true
                           nplist.push(nPoint)
                         end
                       end
                     end
                   end
                 end
               end
             end
          end
          plist = nplist
        end while plist.length > 0
        @objs.push(@currentObj)
      end
    end
  end

  def getXY(pixie_index)
    retX = pixie_index % @img.columns
    retY = ((pixie_index - retX) / @img.columns) # + 1

    return retX, retY
  end

  def getIndexXY(x, y)
    retIdx = y * @img.columns
    retIdx += x

    return retIdx    
  end

end

class HighestThoughts
  def initialize()
    inputSource = InputSource.new()
    inputSource.printsize
    inputSource.findobjects
    inputSource.listobjects
  end
end

ht = HighestThoughts.new()

