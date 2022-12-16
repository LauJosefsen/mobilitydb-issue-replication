CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_raster;
CREATE EXTENSION IF NOT EXISTS mobilitydb;

CREATE TABLE fact_cell (
    cell_x integer NOT NULL,
    cell_y integer NOT NULL,
    PRIMARY KEY (cell_x, cell_y),
    st_bounding_box stbox NOT NULL
);

CREATE INDEX fact_cell_st_bounding_box_idx ON fact_cell USING spgist (st_bounding_box);