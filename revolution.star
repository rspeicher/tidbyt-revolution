load("render.star", "render")
load("http.star", "http")
load("cache.star", "cache")
load("humanize.star", "humanize")
load("time.star", "time")

def image(asset_url, name):
    cached = cache.get(name)
    if cached:
        return cached

    image_url = asset_url + "images/" + name + ".png"
    response = http.get(image_url)

    if response.status_code != 200:
        fail("Image not found", image_url)

    data = response.body()
    cache.set(name, data)

    return data

def main(config):
    timezone = config.get("$tz") or "America/Mexico_City"
    asset_url = config.get("$asset_url")

    now = time.now().in_location(timezone)

    return render.Root(
        child=render.Row(
            expanded=True,
            children = [
                render.Padding(
                    pad=(0, 0, 4, 0),
                    child=render.Box(
                        width=32,
                        height=32,
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
                                        render.Image(src=image(asset_url, "date_%s" % int(now.hour / 10)), height=15),
                                        render.Image(src=image(asset_url, "date_%s" % int(now.hour % 10)), height=15),
                                    ]
                                ),
                                # Minute
                                render.Row(
                                    expanded=True,
                                    main_align="space_between",
                                    children=[
                                        render.Image(src=image(asset_url, "date_%s" % int(now.minute / 10)), height=15),
                                        render.Image(src=image(asset_url, "date_%s" % int(now.minute % 10)), height=15),
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
                            child=render.Image(src=image(asset_url, "day_%s" % humanize.day_of_week(now))),
                        ),
                        # Date
                        render.Row(
                            children=[
                                # TODO: Order of month and day
                                # Month
                                render.Padding(
                                    pad=(0, 0, 1, 0),
                                    child=render.Image(src=image(asset_url, "second_%s" % int(now.month / 10)), height=5),
                                ),
                                render.Padding(
                                    pad=(0, 0, 2, 0),
                                    child=render.Image(src=image(asset_url, "second_%s" % int(now.month % 10)), height=5),
                                ),
                                # Day
                                render.Padding(
                                    pad=(0, 0, 1, 0),
                                    child=render.Image(src=image(asset_url, "second_%s" % int(now.day / 10)), height=5),
                                ),
                                render.Image(src=image(asset_url, "second_%s" % int(now.day % 10)), height=5),
                            ]
                        )
                    ]
                )
            ]
        )
    )
