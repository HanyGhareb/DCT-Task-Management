"""Small renderer for this deck's simple vector shapes and text.

Used because the container's LibreOffice process cannot create its runtime profile.
The PDF remains visually aligned with the editable PPTX and needs no external package.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
from pptx import Presentation
from pptx.enum.shapes import MSO_SHAPE_TYPE, MSO_AUTO_SHAPE_TYPE
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR

SRC = Path("deliverables/ai-for-business-course/AI_for_Everyday_Business_Course.pptx")
OUT = SRC.with_suffix(".pdf")
PREVIEW = SRC.parent / "preview"
PREVIEW.mkdir(exist_ok=True)
W, H = 1600, 900

def rgb(c, default=(255,255,255)):
    try:
        v = c.rgb
        return (v[0], v[1], v[2]) if v else default
    except Exception:
        return default

def font(size, bold=False):
    p = "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/dejavu/DejaVuSans.ttf"
    return ImageFont.truetype(p, max(8, int(size*W/960)))

def fit_lines(draw, text, f, width):
    lines=[]
    for hard in text.split("\n"):
        words=hard.split()
        if not words:
            lines.append(""); continue
        line=words[0]
        for word in words[1:]:
            test=line+" "+word
            if draw.textbbox((0,0),test,font=f)[2] <= width:
                line=test
            else:
                lines.append(line); line=word
        lines.append(line)
    return lines

prs=Presentation(SRC)
sx=W/prs.slide_width; sy=H/prs.slide_height
pages=[]
for si,slide in enumerate(prs.slides,1):
    bg=rgb(slide.background.fill.fore_color,(255,255,255))
    im=Image.new("RGB",(W,H),bg); draw=ImageDraw.Draw(im)
    for sh in slide.shapes:
        x=int(sh.left*sx); y=int(sh.top*sy); w=max(1,int(sh.width*sx)); h=max(1,int(sh.height*sy))
        if sh.shape_type == MSO_SHAPE_TYPE.AUTO_SHAPE:
            fill=rgb(sh.fill.fore_color,(255,255,255))
            outline=rgb(sh.line.color,fill)
            typ=sh.auto_shape_type
            if typ == MSO_AUTO_SHAPE_TYPE.OVAL:
                draw.ellipse((x,y,x+w,y+h),fill=fill,outline=outline,width=1)
            elif typ == MSO_AUTO_SHAPE_TYPE.ROUNDED_RECTANGLE:
                draw.rounded_rectangle((x,y,x+w,y+h),radius=max(3,int(min(w,h)*.12)),fill=fill,outline=outline,width=1)
            else:
                draw.rectangle((x,y,x+w,y+h),fill=fill,outline=outline,width=1)
        if not getattr(sh,"has_text_frame",False) or not sh.text_frame.text:
            continue
        tf=sh.text_frame
        ml=int(tf.margin_left*sx); mr=int(tf.margin_right*sx); mt=int(tf.margin_top*sy); mb=int(tf.margin_bottom*sy)
        tx=x+ml; tw=max(4,w-ml-mr)
        blocks=[]; total=0
        for p in tf.paragraphs:
            text=p.text
            first=p.runs[0] if p.runs else None
            sz=(first.font.size.pt if first and first.font.size else 18)
            bold=bool(first and first.font.bold)
            color=rgb(first.font.color,(31,45,61)) if first else (31,45,61)
            f=font(sz,bold); lines=fit_lines(draw,text,f,tw)
            lh=int(f.size*1.18); ph=max(lh,len(lines)*lh)
            blocks.append((p,lines,f,color,lh,ph)); total += ph
        if tf.vertical_anchor == MSO_ANCHOR.MIDDLE:
            ty=y+(h-total)//2
        elif tf.vertical_anchor == MSO_ANCHOR.BOTTOM:
            ty=y+h-mb-total
        else:
            ty=y+mt
        for p,lines,f,color,lh,ph in blocks:
            for line in lines:
                bw=draw.textbbox((0,0),line,font=f)[2]
                if p.alignment == PP_ALIGN.CENTER: lx=tx+(tw-bw)//2
                elif p.alignment == PP_ALIGN.RIGHT: lx=tx+tw-bw
                else: lx=tx
                draw.text((lx,ty),line,font=f,fill=color,anchor="lt")
                ty += lh
    png=PREVIEW/f"slide-{si:02d}.png"; im.save(png,optimize=True)
    pages.append(im)
pages[0].save(OUT,"PDF",resolution=150.0,save_all=True,append_images=pages[1:])
print(f"{OUT} ({len(pages)} pages)")
