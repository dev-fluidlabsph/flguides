package com.sample.domain;
import org.springframework.roo.addon.dbre.RooDbManaged;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.entity.RooJpaEntity;
import org.springframework.roo.addon.tostring.RooToString;

@RooJavaBean
@RooJpaEntity(table = "salary", schema = "public")
@RooDbManaged(automaticallyDelete = true)
@RooToString(excludeFields = { "employees" })
public class Salary {
}
