#!/Users/ian/.rvm/rubies/ruby-2.2.0/bin/ruby

require 'RMagick'
include Magick


class ImageObject
  def initialize(isWhite,fieldWidth,fieldHeight)
    @fieldWidth = fieldWidth
    @fieldHeight = fieldHeight
    @pixels = Array.new(getIndexXY(fieldWidth,fieldHeight),false)
    @isWhite = isWhite
  end

  def addPixel(x,y)
    @pixels[getIndexXY(x,y)] = true
  end

  def isWhite
    return @isWhite
  end

  def listob
      puts("isWhite = #{@isWhite}")
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
    @img = Magick::Image.read('triangle.png')[0]
    @iPixels = @img.get_pixels(0,0,@img.columns,@img.rows)
    @objs = Array.new
  end

  def listobjects()
    puts("Number of objects: #{@objs.length}")
    @objs.each do |ob|
      ob.listob
    end
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
        if (@iPixels[pixie].red == 65535)
          useWhite=true
        else
          useWhite=false
        end
#    create new object with first pixel set
        @currentObj = ImageObject.new(useWhite,@img.columns,@img.rows)
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
                       if (@iPixels[padj].red == 65535)
                         newWhite=true
                       else
                         newWhite=false
                       end
       
                       if newWhite == useWhite
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
        puts(@currentObj.printAsStrings)
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

