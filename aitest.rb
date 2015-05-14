#!/Users/ian/.rvm/rubies/ruby-2.2.0/bin/ruby

require 'RMagick'
include Magick


class ImageObject
  def initialize(isWhite)
    @isWhite = isWhite
    @points = Array.new
#    @pointsX = Array.new
#    @pointsX.push(x)
#    @pointsY = Array.new
#    @pointsY.push(y)
  end

  def addPixel(x,y)
    aPoint=Array.new()
    aPoint.push(x)
    aPoint.push(y)
    if (!@points.index(aPoint))
      @points.push(aPoint)
    end
#     if @pointsX.index(x) == nil || @pointsY.index(y) == nil
#      @pointsX.push(x)
#      @pointsY.push(y)
#    end
#    alreadyThere=false
#    @pointsX.each_index do |recheck|
#      if @pointsX[recheck] == x && @pointsY[recheck] == y
#        alreadyThere=true
#      end
#    end
#    if alreadyThere==false
#      @pointsX.push(x)
#      @pointsY.push(y)
#    end
  end

  def isWhite
    return @isWhite
  end

  def listob
      puts("isWhite = #{@isWhite}")
      puts("points.length = #{@points.length}")
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
        @currentObj = ImageObject.new(useWhite)
        @currentObj.addPixel(x,y)
#    create new point list
        plist = Array.new
#        xlist = Array.new
#        ylist = Array.new
        @currentObj.listob
#    add x,y to new point list
        aPoint=Array.new()
        aPoint.push(x)
        aPoint.push(y)
        plist.push(aPoint)
#        xlist.push(x)
#        ylist.push(y)
        begin
          nplist = Array.new
#          nxlist = Array.new
#          nylist = Array.new
          plist.each do |chkpoint|
#            x = xlist[chkpoint]
#            y = ylist[chkpoint]
            @currentObj.addPixel(chkpoint[0],chkpoint[1])
            padj = getIndexXY(chkpoint[0],chkpoint[1])
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
#                         alreadyThere=false
#                         nplist.each_index do |recheck|
#                           if nplist[recheck].x == aPoint.x+i && nplist[recheck].y == aPoint.y+j
#                             alreadyThere=true
#                           end
#                         end
                         if nplist.index(nPoint) == nil
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
#          ylist = nylist
        end while plist.length > 0
puts("Pushing Object")
        @objs.push(@currentObj)
      end
    end
#    add each point in new point list
#    to current object
#    add each point adjacent to all the points in new point list where the points are same colour as object & aren't already in the object to a replacement new point list
#    until new point list is empty
#    end if
#    add 1 to x
#    if x > width
#    x=0
#    y += 1
#    end if
#    until y>height
    

#    @iPixels.each_index do |pixie|
#      if (!@usedPixel[pixie])
#         if (@iPixels[pixie].red = 65535)
#           useWhite=true
#         else
#           useWhite=false
#         end
#         x,y = getXY(pixie)
#         @currentObj = ImageObject.new(useWhite,x,y)
#         @objs.push(@currentObj)
#         @usedPixel[pixie]=true
#         addAdjacent(x,y)
#      end
#    end
  end

  def isNewPoint(isWhite,x,y)
    if (x<0)
      return false
    end

    if (x > @img.columns)
      return false
    end

    if (y<0)
      return false
    end

    if (y > @img.rows)
      return false
    end

    pixie = getIndexXY(x,y)

    if (pixie < 0) || (pixie > @usedPixel.length)
      puts('invalid pixie')
      puts(pixie)
      puts("X = #{x}, Y = #{y}")
      return false
    end

    if @usedPixel[pixie] == true
      return false
    end

    if (@iPixels[pixie].red == 65535)
      if (isWhite) 
        return true
      end
    else
      if (!isWhite)
        return true
      end
    end

    return false
#    if (@iPixels[pixie].red == 65535)
      useWhite=true
#    else
#      useWhite=false
#    end

    if (useWhite && isWhite)||((!useWhite) && (!isWhite))
      return true
    else
      return false
    end
  end

  def getXY(pixie_index)
    retX = pixie_index % @img.columns
    retY = ((pixie_index - retX) / @img.columns) # + 1

#    if (retX == 0)
#      retX = @img.columns
#      retY -= 1
#    end

    return retX, retY
  end

  def getIndexXY(x, y)
    retIdx = y * @img.columns
    retIdx += x

    return retIdx    
  end

#  def addAdjacent(x,y)
#    puts("addAdjacent(#{x},#{y})")
#
#    x1 = x
#    y1 = y - 1
#    x2 = x - 1
#    y2 = y
#    x3 = x + 1
#    y3 = y
#    x4 = x
#    y4 = y + 1
#
#    if (y1 >= 0)
#      i1 =  getIndexXY(x1,y1)
#      p1 = @iPixels[i1]
#      if (@usedPixel[i1] == false)
#        if ((@currentObj.isWhite) && (p1.red == 65535))||((!@currentObj.isWhite) && (p1.red != 65535))
#          @currentObj.addPixel(x1,y1)
#          @usedPixel[i1] = true
#          addAdjacent(x1,y1)
#        end  
#      end
#    end
#
#    if (x2 >= 0)
#      i2 =  getIndexXY(x2,y2)
#      p2 = @iPixels[i2]
#      if (@usedPixel[i2] == false)
#        if ((@currentObj.isWhite) && (p2.red == 65535))||((!@currentObj.isWhite) && (p2.red != 65535))
#          @currentObj.addPixel(x2,y2)
#          @usedPixel[i2] = true
#          addAdjacent(x2,y2)
#        end  
#      end
#    end
#
#    if (x3 <= @img.columns)
#      i3 =  getIndexXY(x3,y3)
#      p3 = @iPixels[i3]
#      if (!@usedPixel[i3])
#        if ((@currentObj.isWhite) && (p3.red == 65535))||((!@currentObj.isWhite) && (p3.red != 65535))
#          @currentObj.addPixel(x3,y3)
#          @usedPixel[i3] = true
#          addAdjacent(x3,y3)
#        end  
#      end
#    end
#
#    if (y4 <= @img.rows)
#      i4 =  getIndexXY(x4,y4)
#      p4 = @iPixels[i4]
#      if (!@usedPixel[i4])
#        if ((@currentObj.isWhite) && (p4.red == 65535))||((!@currentObj.isWhite) && (p4.red != 65535))
#          @currentObj.addPixel(x4,y4)
#          @usedPixel[i4] = true
#          addAdjacent(x4,y4)
#        end  
#      end
#    end
#  end
end

class HighestThoughts
  def initialize()
    inputSource = InputSource.new()
    inputSource.printsize
    inputSource.findobjects
    inputSource.listobjects
  end
end

@pointStruct = Struct.new(:x,:y)
ht = HighestThoughts.new()

