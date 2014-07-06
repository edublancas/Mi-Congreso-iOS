//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBComisionesViewController.h"

@interface EBComisionesViewController ()

@end

@implementation EBComisionesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Setup segmented
    segmented =  [[[[self.childViewControllers objectAtIndex:0]view]subviews]objectAtIndex:0];
    [segmented addTarget:self action:@selector(filtrar)
        forControlEvents:UIControlEventValueChanged];
    [segmented setSelectedSegmentIndex:0];
    
    [self descargarListaComisiones];
}

-(void)descargarListaComisiones{
    //Setup strings
    NSString *ordinariasSenadoString = [NSString stringWithFormat:@"%@?ver=int&mn=12", kSenadoresBaseURL];
    NSString *ordinariasDiputadosString = [NSString stringWithFormat:@"%@LXII_leg/listado_de_comisioneslxii.php?tct=1", kDiputadosBaseURLsitl];
    
    //Check if file exists
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathD = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasDiputados.plist"];
    NSString *pathS = [documentsDirectory stringByAppendingString:@"/comisionesOrdinariasSenadores.plist"];
    
    ///If files exists load content, if not create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathS]){
        
        //Parsing comisiones senadores (ordinarias)
        [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
        
        NSURL *URL = [NSURL URLWithString:ordinariasSenadoString];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                NSString *queryString = @"//html/body/div/div/div/table/tr/td";
                NSArray *nodos = [parser searchWithXPathQuery:queryString];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                
                //Do something with the data
                for (TFHppleElement *element in nodos) {
                    NSString *nombre = [[[element firstChildWithTagName:@"a"]firstChild]content];
                    NSString *integrantes = [[[[[element firstChildWithTagName:@"div"]firstChildWithTagName:@"blockquote"]childrenWithTagName:@"a"]objectAtIndex:0]objectForKey:@"href"];
                    NSString *sitioweb = [[[[[element firstChildWithTagName:@"div"]firstChildWithTagName:@"blockquote"]childrenWithTagName:@"a"]objectAtIndex:1]objectForKey:@"href"];
                    
                    NSString *integrantesFull = [NSString stringWithFormat:@"%@%@", kSenadoresBaseURL, integrantes];
                    
                    
                    if (nombre.length && integrantes.length && sitioweb.length) {
                        //NSLog(@"Nombre: %@ Integrantes: %@ Sitio: %@", nombre, integrantes, sitioweb);
                        
                        EBComision *c = [[EBComision alloc]initWithNombre:nombre integrantes:[NSURL URLWithString:integrantesFull] sitioWeb:[NSURL URLWithString:sitioweb] type:kSenador];
                        
                        [temp addObject:c];
                    }
                    
                }
                
                comisionesOrdinariasSenadores = [[NSArray alloc]initWithArray:temp];
                //NSLog(@"senadores com: %@", comisionesOrdinariasSenadores);
                
                
                //Save file as plist
                NSMutableArray *arrayToExport = [[NSMutableArray alloc]init];
                for (EBComision *com in comisionesOrdinariasSenadores)
                    [arrayToExport addObject:[com exportAsDictionary]];

                [arrayToExport writeToFile:pathS atomically: YES];
                //NSLog(@"Saving: %@", arrayToExport);
                
                
                [self.tableView reloadData];
                [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            }
            else if (error){
                NSLog(@"%@",error);
                [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            }
        }];
        
        
    }else{
        //Load local files
        NSLog(@"Cargando archivo local de comisiones del Senado...");
        
        NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathS];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        
        for (NSDictionary *comisionDic in plistArray) {
            EBComision *c = [[EBComision alloc]initWithDic:comisionDic type:kSenador];
            [temp addObject:c];
        }
        comisionesOrdinariasSenadores = [[NSArray alloc]initWithArray:temp];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathD]){
        NSDictionary *emptyDic = [NSDictionary dictionary];
        [emptyDic writeToFile:pathD atomically:YES];
        
        [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
        //Parsing comisiones diputados (ordinarias)
        NSURL * URL = [NSURL URLWithString:ordinariasDiputadosString];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                NSString *queryString = @"//body/table/tr/td/table/tr";
                NSArray *nodos = [parser searchWithXPathQuery:queryString];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                
                //Do something with the data
                for (TFHppleElement *element in nodos) {
                    if ([[element childrenWithTagName:@"td"]count]==4) {
                        
                        NSString *nombre = [[[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]firstChild]content];
                        NSString *integrantes = [[[[element childrenWithTagName:@"td"]objectAtIndex:0]firstChildWithTagName:@"a"]objectForKey:@"href"];
                        NSString *integrantesFull = [NSString stringWithFormat:@"%@LXII_leg/%@", kDiputadosBaseURLsitl,integrantes];
                        
                        
                        NSString *sitioweb = [[[[element childrenWithTagName:@"td"]objectAtIndex:3]firstChildWithTagName:@"a"]objectForKey:@"href"];
                        
                        //Nota: no todas las comisiones tienen sitio web por eso no se toma en cuenta en el siguiente if
                        
                        if (nombre.length && integrantes.length) {
                            EBComision *c = [[EBComision alloc]initWithNombre:nombre integrantes:[NSURL URLWithString:integrantesFull] sitioWeb:[NSURL URLWithString:sitioweb] type:kDiputado];
                            
                            [temp addObject:c];
                        }
                    }
                    
                }
                
                comisionesOrdinariasDiputados = [[NSArray alloc]initWithArray:temp];
                
                
                //Save file as plist
                NSMutableArray *arrayToExport = [[NSMutableArray alloc]init];
                for (EBComision *com in comisionesOrdinariasDiputados)
                    [arrayToExport addObject:[com exportAsDictionary]];
                
                [arrayToExport writeToFile:pathD atomically: YES];
                //NSLog(@"Saving: %@", arrayToExport);
                
                [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
                [self.tableView reloadData];
                
                //NSLog(@"dip com: %@", comisionesOrdinariasDiputados);
                
            }
            else if (error)
                NSLog(@"%@",error);
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
        }];

    }else{
        //Load local files
        NSLog(@"Cargando archivo local de comisiones de la Cámara de Diputados...");
        
        NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathD];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        
        for (NSDictionary *comisionDic in plistArray) {
            EBComision *c = [[EBComision alloc]initWithDic:comisionDic type:kDiputado];
            [temp addObject:c];
        }
        comisionesOrdinariasDiputados = [[NSArray alloc]initWithArray:temp];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (segmented.selectedSegmentIndex==0 ? comisionesOrdinariasSenadores.count : comisionesOrdinariasDiputados.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    if (segmented.selectedSegmentIndex==0) {
        //Senadores
        cell.textLabel.text = [[comisionesOrdinariasSenadores objectAtIndex:indexPath.row]nombre];
    }else{
        cell.textLabel.text = [[comisionesOrdinariasDiputados objectAtIndex:indexPath.row]nombre];
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBComision *c;
    
    if (segmented.selectedSegmentIndex==0) {
        //Senadores
        c  = [comisionesOrdinariasSenadores objectAtIndex:indexPath.row];
    }else{
        //Diputados
        c  = [comisionesOrdinariasDiputados objectAtIndex:indexPath.row];
    }
    
    EBComisionDetailsViewController *d = [[EBComisionDetailsViewController alloc]initWithComision:c];
    
    [self.navigationController pushViewController:d animated:YES];
}

#pragma mark - Segmented control

-(void)filtrar{
    if (segmented.selectedSegmentIndex==0) {
        //Senadores
        NSLog(@"Mostrando comisiones del senado...");
    }else{
        //Diputados
        NSLog(@"Mostrando comisiones de la cámara de diputados...");
    }
    [self.tableView reloadData];
    
}

@end
