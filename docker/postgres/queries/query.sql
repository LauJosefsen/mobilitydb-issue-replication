WITH q_window(box, start_date_id, end_date_id) AS (
        SELECT SetSRID(STBox(
            ST_Transform(
                ST_MakeEnvelope(
                    10.817894, 
                    57.164297, 
                    11.287206, 
                    57.376069, 
                    4326
                ), 
                3034
            ),
            period('2022-02-01 00:10:00+00', '2022-02-28 23:55:00+00')
        ), 3034) box,
        20220101             start_date_id,
        20220101             end_date_id
    ),
    raster_ref(rast) AS (
        SELECT ST_MakeEmptyRaster(
            30000,
            25000,
            4047800,
            3379700,
            25,
            25,
            0,
            0,
            3034)
    )
SELECT ST_Union(ST_AsRaster(
    grp.center_point,
    raster_ref.rast,
    '8BSI'::text,
    grp.cnt
))
FROM 
    raster_ref,
    (
        SELECT 
            ST_SetSRID(ST_Centroid(fc.st_bounding_box::geometry), 3034)   AS center_point,
            COUNT(fc.*)                                AS cnt
        FROM q_window q
        INNER JOIN fact_cell fc ON fc.st_bounding_box && q.box
        GROUP BY fc.cell_x, fc.cell_y, fc.st_bounding_box
    ) AS grp
;