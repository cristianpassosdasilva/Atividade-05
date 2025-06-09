@isTest
private class AccountRepositoryTest {

    /**
     * Cria dados de teste com 3 registros Account contendo nome, salário e data de nascimento.
     */
    static void setupData() {
        List<Account> accounts = new List<Account>{
            new Account(Name='João Silva', Salary__c=3000, Birth_Date__c=Date.newInstance(1990, 5, 10)),
            new Account(Name='Maria Souza', Salary__c=5000, Birth_Date__c=Date.newInstance(1985, 7, 15)),
            new Account(Name='Carlos Oliveira', Salary__c=7000, Birth_Date__c=Date.newInstance(2000, 1, 1))
        };
        insert accounts;
    }

    /**
     * Testa a busca de contas por nome exato (case-insensitive).
     */
    @isTest static void testBuscarNomeExato() {
        setupData();
        List<Account> resultado = AccountRepository.findByExactName('joão silva');
        Assert.areEqual(1, resultado.size());

        List<Account> nenhum = AccountRepository.findByExactName('ana pereira');
        Assert.areEqual(0, nenhum.size());
    }

    /**
     * Testa a busca por parte do nome e com string vazia.
     */
    @isTest static void testBuscarParteDoNome() {
        setupData();
        List<Account> results = AccountRepository.findByNameContains('Souza');
        Assert.areEqual(1, results.size());

        List<Account> empty = AccountRepository.findByNameContains('Zé');
        Assert.areEqual(0, empty.size());

        List<Account> all = AccountRepository.findAllAccounts();
        Assert.isTrue(all.size() >= 3);
    }

    /**
     * Testa filtragem de contas por salário.
     */
    @isTest static void testBuscarPorSalario() {
        setupData();
        List<Account> maiores = AccountRepository.findBySalaryGreaterThan(6000);
        Assert.areEqual(1, maiores.size());

        List<Account> menores = AccountRepository.findBySalaryLessThan(4000);
        Assert.areEqual(1, menores.size());

        List<Account> faixa = AccountRepository.findBySalaryBetween(4000, 6000);
        Assert.areEqual(1, faixa.size());
    }

    /**
     * Testa a busca por data de nascimento entre duas datas.
     */
    @isTest static void testBuscarPorDataNascimento() {
        setupData();
        Date inicio = Date.newInstance(1980, 1, 1);
        Date fim = Date.today();
        List<Account> result = AccountRepository.findByBirthDateBetween(inicio, fim);
        Assert.areEqual(3, result.size());
    }

    /**
     * Testa atualização de campos de uma conta e validação posterior.
     */
    @isTest static void testUpdateCliente() {
        setupData();
        Account acc = [SELECT Id, Name, Salary__c, Birth_Date__c FROM Account WHERE Name = 'João Silva' LIMIT 1];
        acc.Name = 'João Atualizado';
        acc.Salary__c = 9999;
        acc.Birth_Date__c = Date.newInstance(1995, 10, 10);

        AccountRepository.updateAccount(acc);

        Account updated = [SELECT Name, Salary__c, Birth_Date__c FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('João Atualizado', updated.Name);
        Assert.areEqual(9999, updated.Salary__c);
        Assert.areEqual(Date.newInstance(1995, 10, 10), updated.Birth_Date__c);
    }

    /**
     * Testa a busca de todos os registros de conta.
     */
    @isTest static void testFindAll() {
        setupData();
        List<Account> all = AccountRepository.findAll();
        Assert.isTrue(all.size() >= 3);
    }

    /**
     * Testa busca por renda (salário) exata.
     */
    @isTest static void testFindByIncome() {
        setupData();
        List<Account> result = AccountRepository.findByIncome(5000);
        Assert.areEqual(1, result.size());
    }

    /**
     * Testa busca de registro por ID existente.
     */
    @isTest static void testFindByIdSuccess() {
        setupData();
        Account acc = [SELECT Id FROM Account WHERE Name = 'João Silva' LIMIT 1];
        Account found = AccountRepository.findById(acc.Id);
        Assert.areEqual(acc.Id, found.Id);
    }

    /**
     * Testa comportamento ao buscar por ID inexistente (deve lançar exceção).
     */
    @isTest static void testFindByIdNotFound() {
        try {
            AccountRepository.findById('001000000000000AAA');
            Assert.fail('Era esperado lançar exceção');
        } catch (ResourceNotFoundException e) {
            Assert.isTrue(e.getMessage().contains('not'));
        }
    }

    /**
     * Testa exclusão de conta por ID.
     */
    @isTest static void testDeleteById() {
        setupData();
        Account acc = [SELECT Id FROM Account WHERE Name = 'Maria Souza' LIMIT 1];
        AccountRepository.deleteById(acc.Id);

        Account deleted = [SELECT Id, IsDeleted FROM Account WHERE Id = :acc.Id ALL ROWS];
        Assert.isTrue(deleted.IsDeleted);
    }

    /**
     * Testa inserção de novo registro de conta.
     */
    @isTest static void testInsertAccount() {
        Account novo = new Account(Name='Novo Cliente', Salary__c=3200);
        Account result = AccountRepository.insertAccount(novo);
        Assert.isNotNull(result.Id);
        Assert.areEqual('Novo Cliente', result.Name);
    }

}
