load("render.star", "render")
load("humanize.star", "humanize")
load("time.star", "time")
load("pixlib/file.star", "file")
load("pixlib/const.star", "const")

def image(name):
    return file.read("images/" + name + ".png")

def main(config):
    TZ = config.get("$tz") or "America/Mexico_City"

    now = time.now().in_location(TZ)

    return render.Root(
        child=render.Row(
            expanded=True,
            children = [
                render.Padding(
                    pad=(0, 0, 4, 0),
                    child=render.Box(
                        width=const.HEIGHT,
                        height=const.HEIGHT,
                        child=render.Column(
                            expanded=True,
                            main_align="space_between",
                            children=[
                                # Hour
                                render.Row(
                                    expanded=True,
                                    main_align="space_between",
                                    children=[
                                        # TODO: 24 vs 12 hour
                                        # TODO: PM indicator
                                        render.Image(src=image("date_%s" % int(now.hour / 10)), height=15),
                                        render.Image(src=image("date_%s" % int(now.hour % 10)), height=15),
                                    ]
                                ),
                                # Minute
                                render.Row(
                                    expanded=True,
                                    main_align="space_between",
                                    children=[
                                        render.Image(src=image("date_%s" % int(now.minute / 10)), height=15),
                                        render.Image(src=image("date_%s" % int(now.minute % 10)), height=15),
                                    ]
                                ),
                            ]
                        )
                    )
                ),
                render.Column(
                    expanded=True,
                    children=[
                        # Weekday
                        render.Padding(
                            pad=(0, 5, 0, 2),
                            child=render.Image(src=image("day_%s" % humanize.day_of_week(now))),
                        ),
                        # Date
                        render.Row(
                            children=[
                                # TODO: Order of month and day
                                # Month
                                render.Padding(
                                    pad=(0, 0, 1, 0),
                                    child=render.Image(src=image("second_%s" % int(now.month / 10)), height=5),
                                ),
                                render.Padding(
                                    pad=(0, 0, 2, 0),
                                    child=render.Image(src=image("second_%s" % int(now.month % 10)), height=5),
                                ),
                                # Day
                                render.Padding(
                                    pad=(0, 0, 1, 0),
                                    child=render.Image(src=image("second_%s" % int(now.day / 10)), height=5),
                                ),
                                render.Image(src=image("second_%s" % int(now.day % 10)), height=5),
                            ]
                        )
                    ]
                )
            ]
        )
    )
