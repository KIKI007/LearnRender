//
// Created by ziqwang on 2019-10-21.
//

#include "MeshBase.h"
#include "igl/readOBJ.h"
#include "igl/readSTL.h"

bool MeshBase::loadOBJ(const char* filepath){
    V_.setZero();
    F_.setZero();
    if(igl::readOBJ(filepath, V_, F_)){
        std::cout << filepath << " loaded!" << std::endl;
        std::cout << "V: " << V_.rows() << "\t, F: " << F_.rows() << std::endl;
        return true;
    }
    else{
        std::cout << filepath << " did not find!" << std::endl;
        return false;
    }
   
}

bool MeshBase::loadSTL(const char *filepath){
    V_.setZero();
    F_.setZero();
    return igl::readSTL(filepath, V_, F_, N_);
}
