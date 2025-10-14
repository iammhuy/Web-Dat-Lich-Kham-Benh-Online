package app.business.nguoidung;

import javax.persistence.*;

@Entity
@Table(name = "BenhNhan")
@DiscriminatorValue("BenhNhan")
@PrimaryKeyJoinColumn(name = "userId")
public class BenhNhan extends User {

    @Column(name = "MEDICALHISTORY") 
    private String medicalHistory;

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }
}
