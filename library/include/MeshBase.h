//
// Created by ziqwang on 2019-10-21.
//

#ifndef LIBRARY_MESHBASE_H
#define LIBRARY_MESHBASE_H

#include <Eigen/Dense>
#include <iostream>
using Eigen::MatrixXd;
using Eigen::MatrixXi;

class MeshBase{
public:

    MatrixXd V_;
    MatrixXi F_;
    MatrixXd N_;

public:
    MeshBase(){
        
    }
    
    ~MeshBase(){
        
    }

    bool loadOBJ(const char* filepath);

    bool loadSTL(const char *filepath);

public:

    void printV(){
        std::cout << V_ << std::endl;
    }

    void printF(){
        std::cout << F_ << std::endl;
    }
};

#endif //LIBRARY_MESHBASE_H
