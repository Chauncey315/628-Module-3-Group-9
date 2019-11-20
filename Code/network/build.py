import graph_tool.all as gt 
import numpy as np 

g = gt.price_network(2000)
deg = g.degree_property_map("in")
deg.a = 4 * (np.sqrt(deg.a) * 0.5 + 0.4)
ebet = gt.betweenness(g)[1]
ebet.a /= ebet.a.max() / 10.
eorder = ebet.copy()
eorder.a *= -1
pos = gt.sfdp_layout(g)
gt.graph_draw(g, pos=pos, vertex_size=deg, vertex_fill_color=deg, vorder=deg, edge_color=ebet, eorder=eorder, edge_pen_width=ebet, output="output1.svg")