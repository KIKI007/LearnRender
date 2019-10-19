//
//  Greeting.cpp
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#include "Greeting.hpp"
#include "Eigen/Dense"
#include "igl/readOBJ.h"

void readOBJ(const char * file_path){
    Eigen::MatrixXd V;
    Eigen::MatrixXi F;
    igl::readOBJ(file_path, V, F);
    std::cout << V << std::endl;
}
