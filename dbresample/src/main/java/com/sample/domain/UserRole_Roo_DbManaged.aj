// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.sample.domain;

import com.sample.domain.Account;
import com.sample.domain.UserRole;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.ManyToMany;

privileged aspect UserRole_Roo_DbManaged {
    
    @ManyToMany(mappedBy = "userRoles")
    private Set<Account> UserRole.accounts;
    
    @Column(name = "role_name", length = 255)
    private String UserRole.roleName;
    
    public Set<Account> UserRole.getAccounts() {
        return accounts;
    }
    
    public void UserRole.setAccounts(Set<Account> accounts) {
        this.accounts = accounts;
    }
    
    public String UserRole.getRoleName() {
        return roleName;
    }
    
    public void UserRole.setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
}