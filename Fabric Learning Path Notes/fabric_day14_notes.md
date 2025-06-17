
# 📘 Microsoft Fabric – Study Notes (Day 14)

## 🔷 Module: Work with Delta Lake tables in Microsoft Fabric  
🔗 [Link to module](https://learn.microsoft.com/en-us/training/modules/work-delta-lake-tables-fabric/?WT.mc_id=cloudskillschallenge_b696c18d-7201-4aff-9c7d-d33014d93b25)

### 🧠 Key Concepts:
🔹 **Delta Lake** enables ACID transactions and time travel capabilities within Microsoft Fabric’s Lakehouse  
🔹 Delta format is default in Lakehouses and supports schema enforcement, updates, deletes, and version history  
🔹 Delta tables can be queried using both **Spark notebooks** and **SQL Endpoints**

### 🔧 What I practiced:
🔹 Used SQL commands like `DESCRIBE HISTORY` to view table versioning  
🔹 Performed `MERGE`, `UPDATE`, `DELETE`, and `INSERT` operations on Delta tables  
🔹 Observed how **schema evolution** behaves when appending new data  
🔹 Verified time travel with version-based queries (e.g. `VERSION AS OF`)

### ✅ Summary Takeaways:
🔹 Delta Lake brings structure, reliability, and flexibility to Lakehouse data  
🔹 Being able to trace data changes and revert versions is a huge plus for auditing and debugging  
🔹 SQL support makes it accessible even without Spark-specific skills  
🔹 Fabric makes managing Delta tables smooth through both visual and code-based workflows
